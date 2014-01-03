require 'bibtex'
require 'httparty'
require 'json'

class DOIref	
	def self.lookup_bib(doi, style='bibtex')
		input = ARGV[0].to_s
		out = HTTParty.get('http://dx.doi.org/' + doi, :headers => {"Accept" => "text/bibliography; style=" + style})
		outout = BibTeX.parse(out.to_s)
		outout.display
	end
end
# lookup_bib(input)

class CRSearch
	def self.cr_search(query)
		query = [query]
		url = "http://search.labs.crossref.org/links"
		out = 
			HTTParty.post(url, 
				:body => query.to_json, 
				:headers => { "Content-Type" => "application/json"}
			)
		if out.code == 200
			nil
		else
			puts "ERROR #{out.code}"
		end
		tt = out['results']
		coll = []
		tt.each do |item|
			gg = item['doi']
			if gg!=nil
				gg = gg.sub('http://dx.doi.org/', '')
			end
			coll << 
			{
				'match'=>item['match'], 
				'doi'=>gg,
				'text'=>item['text']
			}
		end
        coll.display
        # coll.each { |i| i.display }
	end
end