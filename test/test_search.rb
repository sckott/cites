require "cites"
require 'fileutils'
require "test/unit"
 
class TestResponse < Test::Unit::TestCase
 
  def setup
    # Set up a separate cache to that actually used by cites
    @original_cache = Cites::getcache()
    @test_cache = File.join(File.dirname(@original_cache), "test_cache")
    APICache.store = Moneta.new(:File, dir: @test_cache)

    # Mandatory keywords and values
    @style = 'apa'
    @locale = 'en-US'

    @search_text = 'Piwowar sharing data increases citation PLOS'
    @doi = '10.1371/journal.pone.0000308'
    
    @search_result = {"meta"=>
                      {"totalResults"=>872047,
                       "startIndex"=>0,
                       "itemsPerPage"=>10,
                       "query"=>
                        {"searchTerms"=>"Piwowar sharing data increases citation PLOS",
                         "startPage"=>1}},
                     "items"=>
                      [{"doi"=>"http://dx.doi.org/10.1371/journal.pone.0000308",
                        "normalizedScore"=>100,
                        "title"=>
                         "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                        "year"=>"2007"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2007.361.1",
                        "normalizedScore"=>98,
                        "title"=>
                         "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                        "year"=>"2007"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2007.361",
                        "normalizedScore"=>98,
                        "title"=>
                         "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                        "year"=>"2007"},
                       {"doi"=>"http://dx.doi.org/10.1002/meet.14504701445",
                        "normalizedScore"=>68,
                        "title"=>
                         "Evaluating data citation and sharing policies in the environmental sciences",
                        "year"=>"2010"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2008.1701",
                        "normalizedScore"=>56,
                        "title"=>"Prevalence and Patterns of Microarray Data Sharing",
                        "year"=>"2008"},
                       {"doi"=>"http://dx.doi.org/10.1371/journal.pmed.0050183",
                        "normalizedScore"=>54,
                        "title"=>
                         "Towards a Data Sharing Culture: Recommendations for Leadership from Academic Health Centers",
                        "year"=>"2008"},
                       {"doi"=>"http://dx.doi.org/10.7717/peerj.175",
                        "normalizedScore"=>52,
                        "title"=>"Data reuse and the open data citation advantage",
                        "year"=>"2013"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2008.1701.1",
                        "normalizedScore"=>52,
                        "title"=>"Prevalence and Patterns of Microarray Data Sharing",
                        "year"=>"2008"},
                       {"doi"=>"http://dx.doi.org/10.1371/journal.pone.0018657",
                        "normalizedScore"=>43,
                        "title"=>
                         "Who Shares? Who Doesn't? Factors Associated with Openly Archiving Raw Research Data",
                        "year"=>"2011"},
                       {"doi"=>"http://dx.doi.org/10.1371/journal.pbio.0040176",
                        "normalizedScore"=>43,
                        "title"=>"Open Access Increases Citation Rate",
                        "year"=>"2006"}]}
    
    @doi_result_text = "Piwowar, H. A., Day, R. S., & Fridsma, D. B. (2007). " \
                       "Sharing Detailed Research Data Is Associated with " \
                       "Increased Citation Rate. PLoS ONE, 2(3), e308. " \
                       "doi:10.1371/journal.pone.0000308\n"
    
    @doi_result_json = {"subtitle"=>[],
                         "subject"=>
                          ["Agricultural and Biological Sciences(all)",
                           "Medicine(all)",
                           "Biochemistry, Genetics and Molecular Biology(all)"],
                         "issued"=>{"date-parts"=>[[2007, 3, 21]]},
                         "score"=>1.0,
                         "prefix"=>"http://id.crossref.org/prefix/10.1371",
                         "author"=>
                          [{"family"=>"Piwowar", "given"=>"Heather A."},
                           {"family"=>"Day", "given"=>"Roger S."},
                           {"family"=>"Fridsma", "given"=>"Douglas B."}],
                         "container-title"=>"PLoS ONE",
                         "page"=>"e308",
                         "deposited"=>{"date-parts"=>[[2014, 3, 6]], "timestamp"=>1394064000000},
                         "issue"=>"3",
                         "title"=>
                          "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                         "editor"=>[{"family"=>"Ioannidis", "given"=>"John"}],
                         "type"=>"journal-article",
                         "DOI"=>"10.1371/journal.pone.0000308",
                         "ISSN"=>["1932-6203"],
                         "URL"=>"http://dx.doi.org/10.1371/journal.pone.0000308",
                         "source"=>"CrossRef",
                         "publisher"=>"Public Library of Science (PLoS)",
                         "indexed"=>{"date-parts"=>[[2014, 3, 8]], "timestamp"=>1394237085568},
                         "volume"=>"2"}
    
    @doi_result_bibtex = "@article{Piwowar_2007,\n  " \
                         "title = {Sharing Detailed Research Data Is Associated with Increased Citation Rate},\n  "\
                         "volume = {2},\n  issn = {1932-6203},\n  "\
                         "url = {http://dx.doi.org/10.1371/journal.pone.0000308},\n  "\
                         "doi = {10.1371/journal.pone.0000308},\n  "\
                         "number = {3},\n  journal = {PLoS ONE},\n  "\
                         "publisher = {Public Library of Science (PLoS)},\n  "\
                         "author = {Piwowar, Heather A. and Day, Roger S. and Fridsma, Douglas B.},\n  "\
                         "editor = {Ioannidis, JohnEditor},\n  "\
                         "year = {2007},\n  month = {mar},\n  "\
                         "pages = {e308}\n}\n"
  end
  
  def teardown
    # Remove the test cache and set the cache back to the origianl location
    # just in case
    FileUtils.rm_rf @test_cache
    APICache.store = Moneta.new(:File, dir: @original_cache)
  end
 
  def test_links_endpoint
    assert_equal(@search_result, Cites.search(@search_text))
  end

  def test_doi_search_text
    format = 'text'
    doi_search(@doi_result_text, format)
  end

  def test_doi_search_json
    format = 'citeproc-json'
  	doi_search(@doi_result_json, format)
  end

  def test_doi_search_bibtex
    format = 'bibtex'
    doi_search(@doi_result_bibtex, format)
  end
 
  def doi_search(correct_response, format)
    # Since we're using a test cache, it won't have any entries
    assert_equal(correct_response, Cites.doi2cit(@doi, format, @style, @locale, 
                 cache=true)[0])
    # Test again with cache, this time the entry should be in the cache
    assert_equal(correct_response, Cites.doi2cit(@doi, format, @style, @locale, 
                 cache=true)[0])
    assert_equal(correct_response, Cites.doi2cit(@doi, format, @style, @locale,
                 cache=false)[0])
    assert_equal(correct_response, Cites.doi2cit(@doi, format, @style, @locale, 
                 cache='flush')[0])
  end

end