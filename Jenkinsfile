pipeline {
  agent any

  stages {
    stage('Test') {
      echo 'Running Rake tests'
      rvm "bundler install"
      rvm "bundle exec rake default"
      rvm "gem build sensu-plugins-druid.gemspec"
      rvm "gem install sensu-plugins-druid-*.gem"
    }
  }
}
