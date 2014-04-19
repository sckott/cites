# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cites/version'

Gem::Specification.new do |s|
  s.name        = 'cites'
  s.version     = Cites::VERSION
  s.date        = '2014-04-19'
  s.summary     = "Gets citations from DOIs"
  s.description = "Search for articles, and get citations from DOIs"
  s.authors     = ["Scott Chamberlain","Joona Lehtomäki"]
  s.email       = 'myrmecocystus@gmail.com'
  s.files       = ["lib/cites.rb"]
  s.homepage    = 'http://github.com/sckott/cites'
  s.licenses    = 'MIT'
  s.require_paths = ["lib"]
  s.bindir      = 'bin'
  s.executables = ['cite']
  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_runtime_dependency 'bibtex-ruby', '~> 3.0'
  s.add_runtime_dependency 'httparty', '~> 0.12'
  s.add_runtime_dependency 'thor', '~> 0.18'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'api_cache', '~> 0.2'
  s.add_runtime_dependency 'moneta', '~> 0.7'
  s.add_runtime_dependency 'launchy', '~> 2.4.2'
end