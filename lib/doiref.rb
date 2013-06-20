require 'bibtex'
require 'httparty'

class DOIref	
	def self.lookup_bib(doi, style='bibtex')
		input = ARGV[0].to_s
		out = HTTParty.get('http://dx.doi.org/' + doi, :headers => {"Accept" => "text/bibliography; style=" + style})
		outout = BibTeX.parse(out.to_s)
		outout.display
	end
end
# lookup_bib(input)