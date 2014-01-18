# module: citescli

class Cites < Thor
  require 'cites'
  require 'launchy'

  desc "search STRING", "Get a DOI from a search string"
  # method_options :doi => :boolean
  def search(tt)
  	tt = "#{tt}"
    tt = tt.to_s.split(',')
    out = Cites.search(tt)
    puts out
    # puts "#{tt}"
    # puts opts["doi"] ? out['doi'] : out
  end
  
  desc "get citation", "Get a citation from a DOI"
  # option :format => nil
  method_option :format, :default => 'text'
  method_option :style, :default => 'apa'
  method_option :locale, :default => 'en-US'
  def getcite(tt)
  	tt = "#{tt}"
  	# puts tt.to_s
  	tt = tt.to_s.split(',')
  	# puts tt
    out = Cites.doi2cit(tt, options[:format], options[:style], options[:locale])
    puts out
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