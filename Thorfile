# module: citescli

class Cite < Thor
  include Thor::Actions
  require 'cites'
  require 'launchy'
  require 'json'
  require 'pp'

  desc "match STRING", "Look for matches in free form citations, get a match and DOI"
  # method_options :doi => :boolean
  def match(tt)
  	tt = "#{tt}"
    tt = tt.to_s.split(',')
    out = Cites.match(tt)
    puts out
  end

  desc "search STRING", "Search for articles via query string or DOI"
  method_option :doi, :default => nil
  method_option :page, :default => nil
  method_option :rows, :default => nil
  method_option :sort, :default => nil
  method_option :year, :default => nil
  def search(tt)
    tt = "#{tt}"
    out = Cites.search(tt, options[:doi], options[:page], options[:rows], options[:sort], options[:year])
    puts out
    # puts "#{tt}"
    # puts opts["doi"] ? out['doi'] : out
  end
  
  desc "get citation", "Get a citation from a DOI"
  method_option :format, :default => 'text'
  method_option :style, :default => 'apa'
  method_option :locale, :default => 'en-US'
  method_option :cache, :default => true
  def get(tt)
  	tt = "#{tt}"
  	# puts tt.to_s
  	tt = tt.to_s.split(',')
  	# puts tt
    begin
      out = Cites.doi2cit(tt, options[:format], options[:style], 
                          options[:locale], options[:cache])
    rescue Exception => e
      abort(e.message)
    end
    
    puts "Found #{out.length} " + (out.length > 1 ? "matches" : "match")
    pp out

  end

  desc "launch paper", "Open a paper from a given DOI in your default browser" 
  method_option :oa, :type => :boolean, :default => 'true'
  def launch(doi)
    if options[:oa]
      url = "http://macrodocs.org/?doi=" + doi
      Launchy.open(url)
    else
      url = "http://dx.doi.org/" + doi
      Launchy.open(url)
    end
  end
end