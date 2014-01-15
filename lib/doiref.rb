require 'bibtex'
require 'httparty'
require 'json'

# DOIref: The single class (for now) in doiref

class DOIref

	def initialize(doi, format='text', style='apa', locale='en-US')
    	@doi = doi
    	@format = format
    	@style = style
    	@locale = locale
  	end

	##
	# Get a citation in various foarmats from a DOI
	#
	# Args: 
	# * doi: A DOI
	# * format: one of rdf-xml, turtle, citeproc-json, text, ris, bibtex, crossref-xml, 
	# * style: Only used if format='text', e.g., apa, harvard3
	# * locale: A locale, e.g., en-US
	# 
	# Examples:
	#     require 'doiref'
	#     DOIref.doi2cit('10.1371/journal.pone.0000308')
	#     DOIref.doi2cit('10.1371/journal.pbio.0030427')
	#     DOIref.doi2cit('10.1371/journal.pbio.0030427', 'crossref-xml')
	#     DOIref.doi2cit('10.1371/journal.pbio.0030427', 'bibtex')
	#     DOIref.doi2cit('10.1371/journal.pbio.0030427', 'ris')
	#
	#     DOIref.doi2cit(['10.1371/journal.pone.0000308','10.1371/journal.pbio.0030427'], 'bibtex')

	# def getcite(doi, format='text', style='apa', locale='en-US')
	def getcite
		formats = {"rdf-xml" => "application/rdf+xml",
			"turtle" => "text/turtle",
			"citeproc-json" => "application/vnd.citationstyles.csl+json",
			"text" => "text/x-bibliography",
			"ris" => "application/x-research-info-systems",
			"bibtex" => "application/x-bibtex",
			"crossref-xml" => "application/vnd.crossref.unixref+xml",
			"datacite-xml" => "application/vnd.datacite.datacite+xml"}
		formatuse = formats[@format]
		if @format == 'text'
			type = formatuse + "; style = " + @style + "; locale = " + @locale
		else
			type = formatuse
		end
		out = HTTParty.get('http://dx.doi.org/' + @doi, :headers => {"Accept" => type})
		if @format == 'bibtex'
			output = BibTeX.parse(out.to_s)
		else
			output = out.to_s
		end
		# output.display
		return output
	end

	# def self.doi2cit(doi, format='text', style='apa', locale='en-US')
	def doi2cit
		if @doi.class == String
			doi = [@doi]
		elsif @doi.class == Array
			doi = @doi
		else
			fail 'doi must be one of String or Array class'
		end		

		cc = []
		doi.each do |iter|
			cc << DOIref.getcite(iter, @format, @style, @locale)
		end

		return cc
	end

	def show(input)
		input.each do |iter|
			puts iter.display,"\n"
		end
	end
end

class Search
	##
	# search: Search for an object (article, book, etc).
	#
	# Args: 
	# * query: A free form string of terms.
	#
	# Examples:
	#     require 'doiref'
	#     Search.search('Piwowar sharing data increases citation PLOS')
	#     Search.search('boettiger Modeling stabilizing selection')
	# 	  Search.search(['Piwowar sharing data increases citation PLOS', 'boettiger Modeling stabilizing selection'])
	# 	  Search.search(['piwowar sharing data increases citation PLOS', 
	# 	  				'boettiger Modeling stabilizing selection',
	# 					'priem Using social media to explore scholarly impact',
	#					'fenner Peroxisome ligands for the treatment of breast cancer'])

	def self.search(query)
		if query.class == String
			query = [query]
		elsif query.class == Array
			query = query
		else
			fail 'query must be one of String or Array class'
		end
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
        # coll.display
        return coll
	end

	def self.getcit(input)
		cc = []
		g.each do |iter|
			cc << iter['doi']
		end
		out = DOIref.doi2cit(cc)
		return out
	end
end