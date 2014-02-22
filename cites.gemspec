Gem::Specification.new do |s|
  s.name        = 'cites'
  s.version     = '0.0.1'
  s.date        = '2014-01-18'
  s.summary     = "Gets citations from DOIs"
  s.description = "Search for articles, and get citations from DOIs"
  s.authors     = ["Scott Chamberlain"]
  s.email       = 'myrmecocystus@gmail.com'
  s.files       = ["lib/cites.rb"]
  s.homepage    = 'http://github.com/sckott/cites'
  s.licenses    = 'CC0'
  s.bindir      = 'bin'
  s.executables = ['crsearch','crref']
  s.add_runtime_dependency 'bibtex-ruby', '~> 3.0'
  s.add_runtime_dependency 'httparty', '~> 0.12'
  s.add_runtime_dependency 'thor', '~> 0.18'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'api_cache', '~> 0.2'
  s.add_runtime_dependency 'moneta', '~> 0.7'
end