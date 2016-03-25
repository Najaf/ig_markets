$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'ig_markets/version'

Gem::Specification.new do |s|
  s.name        = 'ig_markets'
  s.version     = IGMarkets::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.summary     = 'IG Markets API client'
  s.description = 'IG Markets API client for accessing the IG Markets dealing platform'
  s.homepage    = 'https://github.com/rviney/ig_markets'
  s.author      = 'Richard Viney'
  s.email       = 'richard.viney@gmail.com'
  s.files       = `git ls-files`.split("\n")

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency 'rest-client', '~> 1.8'

  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-mocks', '~> 3.4'
  s.add_development_dependency 'rubocop', '~> 0'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
end