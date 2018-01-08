lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'

require_relative 'lib/sensu-plugins-druid'

Gem::Specification.new do |s|
  s.name                   = 'sensu-plugins-druid'
  s.summary                = 'Druid monitoring plugin'
  s.description            = 'Sensu plugin to monitor Druid DB'
  s.authors                = ['Yurii Rochniak']
  s.email                  = 'yrochnyak@gmail.com'
  s.homepage               = 'https://github.com/grem11n/sensu-plugins-druid'
  s.license                = 'MIT'
  s.date                   = Time.zone.today
  s.require_paths          = ['lib']
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  s.metadata               = { 'maintainer'         => 'Yurii Rochniak',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended' }
  s.platform               = Gem::Platform::RUBY
  s.required_ruby_version  = '>= 2.0.0'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsDruid::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'
  s.add_runtime_dependency 'json',         '~> 1.8.6', '>=1.8.6'

  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'github-markup',             '~> 1.3'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 10.5'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rubocop',                   '~> 0.49.0'
  s.add_development_dependency 'rspec',                     '~> 3.4'
  s.add_development_dependency 'yard',                      '~> 0.9.11'
end
