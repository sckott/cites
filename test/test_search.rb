require "./lib/cites"
require 'fileutils'
require "test/unit"
 
class TestResponse < Test::Unit::TestCase
 
  def setup
    # Set up a separate cache to that actually used by cites
    @original_cache = Cites::cache_location
    @test_cache = File.join(File.dirname(@original_cache), "test_cache")
    APICache.store = Moneta.new(:File, dir: @test_cache)

    # Mandatory keywords and values
    @style = 'apa'
    @locale = 'en-US'

    @search_text = 'Piwowar sharing data increases citation PLOS'
    @doi = '10.1371/journal.pone.0000308'
    @search_result = [{"match"=>true, "doi"=>"10.1371/journal.pone.0000308", 
    				   "text"=>"Piwowar sharing data increases citation PLOS"}]
    @doi_result_text = "Piwowar, H. A., Day, R. S., & Fridsma, D. B. (2007). " \
                       "Sharing Detailed Research Data Is Associated with " \
                       "Increased Citation Rate. PLoS ONE, 2(3), e308. " \
                       "doi:10.1371/journal.pone.0000308\n"
    @doi_result_json = {"subtitle" => [],
                   "subject" =>
                          ["Agricultural and Biological Sciences(all)",
                       "Medicine(all)",
                       "Biochemistry, Genetics and Molecular Biology(all)"],
                       "issued" => {"date-parts" => [[2007, 3, 21]]},
                       "score" => 1.0,
                       "author" =>
                          [{"family" => "Piwowar", "given"=>"Heather A."},
                           {"family" => "Day", "given"=>"Roger S."},
                           {"family" => "Fridsma", "given"=>"Douglas B."}],
                       "container-title" => ["PLoS ONE"],
                       "page" => "e308",
                       "deposited" => {"date-parts"=>[[2011, 7, 6]], 
                                       "timestamp"=>1309910400000},
                       "issue" => "3",
                       "title" =>
                          ["Sharing Detailed Research Data Is Associated with" + 
                           " Increased Citation Rate"],
                       "editor" => [{"family"=>"Ioannidis", "given"=>"John"}],
                       "type" => "journal-article",
                       "DOI" => "10.1371/journal.pone.0000308",
                       "ISSN" => ["1932-6203"],
                       "URL" => "http://dx.doi.org/10.1371/journal.pone.0000308",
                       "source" => "CrossRef",
                       "publisher" => "Public Library of Science (PLoS)",
                       "indexed" => {"date-parts" => [[2013, 11, 7]], 
                                     "timestamp" => 1383784241835},
                       "volume" => "2"}
    @doi_result_bibtex = "@article{Piwowar_Day_Fridsma_2007,\n  " \
                         "title = {Sharing Detailed Research Data Is "\
                         "Associated with Increased Citation Rate},\n  "\
                         "volume = {2},\n  issn = {1932-6203},\n  "\
                         "url = {http://dx.doi.org/10.1371/journal.pone.0000308},\n  "\
                         "doi = {10.1371/journal.pone.0000308},\n  "\
                         "number = {3},\n  journal = {PLoS ONE},\n  "\
                         "publisher = {Public Library of Science (PLoS)},\n  "\
                         "author = {Piwowar, Heather A. and Day, Roger S. and "\
                         "Fridsma, Douglas B.},\n  editor = {Ioannidis, "\
                         "JohnEditor},\n  year = {2007},\n  month = {mar},\n  "\
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