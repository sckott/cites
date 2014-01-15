require 'bibtex'
require 'httparty'
require 'json'

# DOIref: The single class (for now) in doiref

class DOIref	
	##
	# doi2cit: Get a citation in various foarmats from a DOI
	#
	# Args: 
	# * doi: A DOI
	# * format: one of rdf-xml, turtle, citeproc-json, text, ris, bibtex, crossref-xml, 
	# * style: Only used if format='text', e.g., apa, harvard3
	# * local: A locale, e.g., en-US

	def self.doi2cit(doi, format='text', style='apa', locale='en-US')
		formats = {"rdf-xml" => "application/rdf+xml",
			"turtle" => "text/turtle",
			"citeproc-json" => "application/vnd.citationstyles.csl+json",
			"text" => "text/x-bibliography",
			"ris" => "application/x-research-info-systems",
			"bibtex" => "application/x-bibtex",
			"crossref-xml" => "application/vnd.crossref.unixref+xml",
			"datacite-xml" => "application/vnd.datacite.datacite+xml"}
		formatuse = formats[format]
		if format == 'text'
			type = formatuse + "; style = " + style + "; locale = " + locale
		else
			type = formatuse
		end
		out = HTTParty.get('http://dx.doi.org/' + doi, :headers => {"Accept" => type})
		if format == 'bibtex'
			output = BibTeX.parse(out.to_s)
		else
			output = out.to_s
		end
		output.display
	end

	def self.search(query)
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
	end
end