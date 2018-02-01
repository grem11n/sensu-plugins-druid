stage('Install dependencies') {
  node {
    checkout scm
    withRvm('ruby-2.3.1') {
      sh 'bundle -v || gem install bundler'
      sh 'bundle install'
      stash includes: 'Gemfile.lock, .bundle', name: 'bundle'
    }
  }
}

stage('Tets') {
  node {
    checkout scm
    withRvm('ruby-2.3.1') {
      unstash 'bundle'
      bundle_exec 'rake default'
    }
  }
}

stage('Build') {
  node {
    checkout scm
    withRvm('ruby-2.3.1') {
      sh 'gem build sensu-plugins-druid.gemspec'
      sh 'gem install sensu-plugins-druid-*.gem'
    }
  }
}

def bundle_exec(command) {
    sh "bundle exec ${command}"
}

def withRvm(version, cl) {
    withRvm(version, "executor-${env.EXECUTOR_NUMBER}") {
        cl()
    }
}

def withRvm(version, gemset, cl) {
    RVM_HOME='$HOME/.rvm'
    paths = [
        "$RVM_HOME/gems/$version@$gemset/bin",
        "$RVM_HOME/gems/$version@global/bin",
        "$RVM_HOME/rubies/$version/bin",
        "$RVM_HOME/bin",
        "${env.PATH}"
    ]
    def path = paths.join(':')
    withEnv(["PATH=${env.PATH}:$RVM_HOME", "RVM_HOME=$RVM_HOME"]) {
        sh "#!/bin/bash\nset +x; source $RVM_HOME/scripts/rvm; rvm use --create --install --binary $version@$gemset"
    }
    withEnv([
        "PATH=$path",
        "GEM_HOME=$RVM_HOME/gems/$version@$gemset",
        "GEM_PATH=$RVM_HOME/gems/$version@$gemset:$RVM_HOME/gems/$version@global",
        "MY_RUBY_HOME=$RVM_HOME/rubies/$version",
        "IRBRC=$RVM_HOME/rubies/$version/.irbrc",
        "RUBY_VERSION=$version"
    ]) {
        cl()
    }
}
