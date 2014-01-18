Gem::Specification.new do |s|
  s.name        = 'doiref'
  s.version     = '0.0.1'
  s.date        = '2014-01-03'
  s.summary     = "Gets citations from DOIs"
  s.description = "Gets citations from DOIs, like bibtex entries"
  s.authors     = ["Scott Chamberlain"]
  s.email       = 'myrmecocystus@gmail.com'
  s.files       = ["lib/doiref.rb"]
  s.homepage    = 'http://github.com/schamberlain/doiref'
  s.licenses    = 'CC0'
  s.bindir      = 'bin'
  s.executables = ['crsearch','crref']
  s.add_runtime_dependency 'bibtex-ruby', '~> 2.3'
  s.add_runtime_dependency 'httparty', '~> 0.11'
  s.add_runtime_dependency 'thor', '~> 0.18'
end