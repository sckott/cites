require 'api_cache'
require 'bibtex'
require 'digest/sha1'
require 'httparty'
require 'json'
require 'moneta'

def response_ok(code)
	# See CrossCite documentation http://crosscite.org/cn/
	case code
	  when 200
	    return true
	  when 204
	  	raise "The request was OK but there was no metadata available (response code: #{code})"
	  when 404
	    raise "The DOI requested doesn't exist (response code: #{code})"
	  when 406
	  	raise "Can't serve any requested content type (response code: #{code})"
	  when 500...600
	    raise "ZOMG ERROR #{code}"
  	end
end

# Cites: The single class (for now) in cites

class Cites

	class << self; attr_accessor :cache_location end
  	@cache_location =  ENV['HOME'] + '/.cites/cache'

 	##
	# Get a single citation in various formats from a DOI
	#
	# Args: 
	# * doi: A DOI
	# * format: one of rdf-xml, turtle, citeproc-json, text, ris, bibtex, crossref-xml, 
	# * style: Only used if format='text', e.g., apa, harvard3
	# * locale: A locale, e.g., en-US
	# * cache: Should cache be used
	# 	* true: Try fetcing from cache and store to cache (default)
	#   * false: Do use cache at all
	#   * 'flush': Get a fresh response and cache it
	#
	def self.getcite(doi, format='text', style='apa', locale='en-US', 
					 cache=true)
		formats = {"rdf-xml" => "application/rdf+xml",
			"turtle" => "text/turtle",
			"citeproc-json" => "application/vnd.citationstyles.csl+json",
			"text" => "text/x-bibliography",
			"ris" => "application/x-rematch-info-systems",
			"bibtex" => "application/x-bibtex",
			"crossref-xml" => "application/vnd.crossref.unixref+xml",
			"datacite-xml" => "application/vnd.datacite.datacite+xml"
		}
		formatuse = formats[format]
		if format == 'text'
			type = "#{formatuse}; style=#{style}; locale=#{locale}"
		else
			type = formatuse
		end
		doi = 'http://dx.doi.org/' + doi

		if cache == true or cache == 'flush'
			if cache == true
				cache_time = 6000
				msg = "Requested DOI not in cache or is stale, requesting..."
			elsif cache == 'flush'
				cache_time = 1
				msg = "Flushing cache, requesting..."
			end
			# Keep cache data valid forever
			# [todo] - should using cache be reported?

			# Create a cache key based on the DOI requested + the type on
			# content
			cache_key = Digest::SHA1.hexdigest("#{doi}-#{type}")

			content = APICache.get(cache_key, :cache => cache_time, 
								   :valid => :forever, :period => 0,
								   :timeout => 30) do
			    puts msg
			    response = HTTParty.get(doi, :headers => {"Accept" => type})
			   
			    # If response code is ok (200) get response body and return
			    # that from this block. Otherwise an error will be raised.
			   	begin
				    if response_ok(response.code)
				    	content = response.body
				    end
					content
				rescue Exception => e
					puts e.message
					puts "Format requested: #{formatuse}"
					exit
				end
			end
		elsif cache == false
			puts "Not using cache, requesting..."
			response = HTTParty.get(doi, :headers => {"Accept" => type})
			
			if response_ok(response.code)
			    content = response.body
			end
		else
			fail "Invalid cache value #{cache}"
		end
		# response = HTTParty.get(doi, :headers => {"Accept" => type})
		if format == 'bibtex'
			output = BibTeX.parse(content).to_s
		else
			output = content
		end
		# output.display
		return output
	end

	##
	# Get a citation in various formats from a DOI
	#
	# Args: 
	# * doi: A DOI
	# * format: one of rdf-xml, turtle, citeproc-json, text, ris, bibtex, crossref-xml, 
	# * style: Only used if format='text', e.g., apa, harvard3
	# * locale: A locale, e.g., en-US
	# * cache: Should cache be used
	# 	* true: Try fetcing from cache and store to cache (default)
	#   * false: Do use cache at all
	#   * 'flush': Get a fresh response and cache it
	# 
	# Examples:
	#     require 'cites'
	#     Cites.doi2cit('10.1371/journal.pone.0000308')
	#     Cites.doi2cit('10.1371/journal.pbio.0030427')
	#     Cites.doi2cit('10.1371/journal.pbio.0030427', 'crossref-xml')
	#     Cites.doi2cit('10.1371/journal.pbio.0030427', 'bibtex')
	#     Cites.doi2cit('10.1371/journal.pbio.0030427', 'ris')
	#
	#     out = Cites.doi2cit(['10.1371/journal.pone.0000308','10.1371/journal.pbio.0030427','10.1371/journal.pone.0084549'], 'bibtex')
	# 	  Cites.show(out)
	#
	# Returns an array of citation content. The structure of the content will 
	# depend on the format requested.
	#
	def self.doi2cit(doi, format='text', style='apa', locale='en-US', 
					 cache=true)
		if doi.class == String
			doi = [doi]
		elsif doi.class == Array
			doi = doi
		else
			fail 'doi must be one of String or Array class'
		end		

		cc = []
		doi.each do |iter|
			# if iter.include?('http://')
			# 	iter = iter.sub('http://dx.doi.org/', '')
			# else
			# 	nil
			# end
			# cc << Cites.getcite(doi=iter, format=format, style=style, locale=locale)
			content = Cites.getcite(iter, format, style, locale, cache)
			if format == 'citeproc-json'
				content = JSON.parse(content)
			end
			cc << content
		end

		return cc
	end

	def self.show(input)
		input.each do |iter|
			puts iter.display,"\n"
		end
	end

	##
	# match: Look for matches to free-form citations to DOIs for an object (article, book, etc). in CrossRef
	#
	# Args: 
	# * query: A free form string of terms.
	#
	# Examples:
	#     require 'cites'
	#     Cites.match('Piwowar sharing data increases citation PLOS')
	#     Cites.match('boettiger Modeling stabilizing selection')
	# 	  Cites.match(['Piwowar sharing data increases citation PLOS', 'boettiger Modeling stabilizing selection'])
	# 	  out = Cites.match(['piwowar sharing data increases citation PLOS', 
	# 	  				'boettiger Modeling stabilizing selection',
	# 					'priem Using social media to explore scholarly impact',
	#					'fenner Peroxisome ligands for the treatment of breast cancer'])
	# 	  out.map {|i| i['doi']}
	#     
	#     # Feed into the doi2cit method
	#     Cites.doi2cit(out.map {|i| i['doi']})
	def self.match(query)
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

	##
	# search: Search for scholary objects in CrossRef
	#
	# Args: 
	# * query: A free form string of terms.
	#
	# Examples:
	#     require 'cites'
	#     Cites.search(query='renear')
	#     Cites.search('palmer')
	# 	  Cites.search(['ecology', 'microbiology'])
	# 	  out = Cites.search(['renear', 'science', 'smith birds'])
	# 	  out.map {|i| i['doi']}
	#     
	#     # Feed into the doi2cit method
	#     out = Cites.search('palmer')
	#     g = Cites.doi2cit(out[1]['doi'], format='bibtex')
	#     Cites.show(g)
	def self.search(query, doi = nil, page = nil, rows = nil, sort = nil, year = nil)
		if query.class == String
			nil
		elsif query.class == Array
			query = query.join('+')
		else
			fail 'query must be one of String or Array class'
		end

		url = "http://search.labs.crossref.org/dois"
		
		if doi == nil
	        args = {"q" => query, "page" => page, "rows" => rows,
            	"sort" => sort, "year" => year}
            args = args.delete_if { |k, v| v.nil? }
	        out = HTTParty.get(url, :body => args)
	        	# :query => args
	        	# )
	        if out.code == 200
				nil
			else
				puts "ERROR #{out.code}"
			end
	        
	        wanted_keys = ["doi","normalizedScore","title","year"]
	        coll = []
			out.each do |item|
				gg = item.reject { |key,_| !wanted_keys.include? key }
				coll << gg
			end
		else
			nil
		end
		return coll
	end
	
	##
	# setcache: Search for scholary objects in CrossRef
	#
	# Args: 
	# * query: A free form string of terms.
	#
	# Examples:
	#     require 'cites'
	#     Cites.search(query='renear')
	#     Cites.search('palmer')
	# 	  Cites.search(['ecology', 'microbiology'])
	# 	  out = Cites.search(['renear', 'science', 'smith birds'])
	# 	  out.map {|i| i['doi']}
	#     
	#     # Feed into the doi2cit method
	#     out = Cites.search('palmer')
	#     g = Cites.doi2cit(out[1]['doi'], format='bibtex')
	#     Cites.show(g)	
end

# [fixme] - Setting the cache_location should really be handled by a method
# but since all the methods in class Cites are static setting the cache
# has to done manually in each static method (because we don't know which
# is called first) or then we would need a propers initializer.

APICache.store = Moneta.new(:File, dir: Cites::cache_location)