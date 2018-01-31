pipeline {
  agent any

  stages {
    stage('Test') {
      echo 'Running Rake tests"
      bundler install
      bundle exec rake default
      gem build sensu-plugins-druid.gemspec
      gem install sensu-plugins-druid-*.gem
    }
  }
}
