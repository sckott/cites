Gem::Specification.new do |s|
  s.name        = 'doiref'
  s.version     = '0.0.1'
  s.date        = '2013-06-20'
  s.summary     = "Gets citations from DOIs"
  s.description = "Gets citations from DOIs, like bibtex entries"
  s.authors     = ["Scott Chamberlain"]
  s.email       = 'myrmecocystus@gmail.com'
  s.files       = ["lib/doiref.rb"]
  s.homepage    = 'http://github.com/schamberlain/doiref'
  s.licenses    = 'CC0'
  s.executables << 'doiref'
  s.add_dependency('bibtex-ruby', '>= 2.3.2')
  s.add_dependency('httparty', '>= 0.11.0')
end