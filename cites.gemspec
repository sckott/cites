# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cites/version'

Gem::Specification.new do |s|
  s.name        = 'cites'
  s.version     = Cites::VERSION
  s.required_ruby_version = '>= 2.0'
  s.date        = '2016-02-20'
  s.summary     = "Gets citations from DOIs"
  s.description = "Search for articles, and get citations from DOIs"
  s.authors     = ["Scott Chamberlain","Joona Lehtomäki"]
  s.email       = 'myrmecocystus@gmail.com'
  s.files       = ["lib/cites.rb"]
  s.homepage    = 'http://github.com/sckott/cites'
  s.licenses    = 'MIT'

  s.files = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]

  s.bindir      = 'bin'
  s.executables = ['cite']

  s.add_development_dependency "bundler", '~> 2.0'
  s.add_development_dependency "rake", '~> 12.3'
  s.add_development_dependency "test-unit", '~> 3.1'

  s.add_runtime_dependency 'bibtex-ruby', '~> 4.0'
  s.add_runtime_dependency 'httparty', '~> 0.13'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'json', '>= 1.8', '< 3.0'
  s.add_runtime_dependency 'api_cache', '~> 0.2'
  s.add_runtime_dependency 'moneta', '>= 0.8', '< 2.0'
  s.add_runtime_dependency 'launchy', '~> 2.4', '>= 2.4.2'
end
