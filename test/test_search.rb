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
                      {"totalResults"=>1063665,
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
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2007.361",
                        "normalizedScore"=>97,
                        "title"=>
                         "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                        "year"=>"2007"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2007.361.1",
                        "normalizedScore"=>97,
                        "title"=>
                         "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                        "year"=>"2007"},
                       {"doi"=>"http://dx.doi.org/10.1002/meet.14504701445",
                        "normalizedScore"=>67,
                        "title"=>
                         "Evaluating data citation and sharing policies in the environmental sciences",
                        "year"=>"2010"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2008.1701",
                        "normalizedScore"=>56,
                        "title"=>"Prevalence and Patterns of Microarray Data Sharing",
                        "year"=>"2008"},
                       {"doi"=>"http://dx.doi.org/10.1371/journal.pmed.0050183",
                        "normalizedScore"=>55,
                        "title"=>
                         "Towards a Data Sharing Culture: Recommendations for Leadership from Academic Health Centers",
                        "year"=>"2008"},
                       {"doi"=>"http://dx.doi.org/10.1038/npre.2008.1701.1",
                        "normalizedScore"=>51,
                        "title"=>"Prevalence and Patterns of Microarray Data Sharing",
                        "year"=>"2008"},
                       {"doi"=>"http://dx.doi.org/10.7717/peerj.175",
                        "normalizedScore"=>51,
                        "title"=>"Data reuse and the open data citation advantage",
                        "year"=>"2013"},
                       {"doi"=>"http://dx.doi.org/10.1371/journal.pone.0018657",
                        "normalizedScore"=>44,
                        "title"=>
                         "Who Shares? Who Doesn't? Factors Associated with Openly Archiving Raw Research Data",
                        "year"=>"2011"},
                       {"doi"=>"http://dx.doi.org/10.1371/journal.pone.0128854",
                        "normalizedScore"=>44,
                        "title"=>
                         "ONION: Functional Approach for Integration of Lipidomics and Transcriptomics Data",
                        "year"=>"2015"}]}

    @doi_result_text = "Piwowar, H. A., Day, R. S., & Fridsma, D. B. (2007). " \
                       "Sharing Detailed Research Data Is Associated with " \
                       "Increased Citation Rate. PLoS ONE, 2(3), e308. " \
                       "doi:10.1371/journal.pone.0000308\n"

    @doi_result_json = {"indexed"=>{"date-parts"=>[[2015, 6, 9]], "timestamp"=>1433824906840},
                        "reference-count"=>0,
                        "publisher"=>"Public Library of Science (PLoS)",
                        "issue"=>"3",
                        "DOI"=>"10.1371/journal.pone.0000308",
                        "type"=>"journal-article",
                        "page"=>"e308",
                        "update-policy"=>"http://dx.doi.org/10.1371/journal.pone.corrections_policy",
                        "source"=>"CrossRef",
                        "title"=>
                         "Sharing Detailed Research Data Is Associated with Increased Citation Rate",
                        "prefix"=>"http://id.crossref.org/prefix/10.1371",
                        "volume"=>"2",
                        "author"=>
                         [{"affiliation"=>[], "family"=>"Piwowar", "given"=>"Heather A."},
                          {"affiliation"=>[], "family"=>"Day", "given"=>"Roger S."},
                          {"affiliation"=>[], "family"=>"Fridsma", "given"=>"Douglas B."}],
                        "member"=>"http://id.crossref.org/member/340",
                        "container-title"=>"PLoS ONE",
                        "deposited"=>{"date-parts"=>[[2014, 3, 6]], "timestamp"=>1394064000000},
                        "score"=>1.0,
                        "subtitle"=>[],
                        "editor"=>[{"affiliation"=>[], "family"=>"Ioannidis", "given"=>"John"}],
                        "issued"=>{"date-parts"=>[[2007, 3, 21]]},
                        "URL"=>"http://dx.doi.org/10.1371/journal.pone.0000308",
                        "ISSN"=>["1932-6203"],
                        "subject"=>
                         ["Agricultural and Biological Sciences(all)",
                          "Medicine(all)",
                          "Biochemistry, Genetics and Molecular Biology(all)"]}

    @doi_result_bibtex = "@article{Piwowar_2007,\n  " \
                         "doi = {10.1371/journal.pone.0000308},\n  "\
                         "url = {http://dx.doi.org/10.1371/journal.pone.0000308},\n  "\
                         "year = {2007},\n  "\
                         "month = {mar},\n  "\
                         "publisher = {Public Library of Science ({PLoS})},\n  "\
                         "volume = {2},\n  "\
                         "number = {3},\n  "\
                         "pages = {e308},\n  "\
                         "author = {Piwowar, Heather A. and Day, Roger S. and Fridsma, Douglas B.},\n  "\
                         "editor = {Ioannidis, John},\n  "\
                         "title = {Sharing Detailed Research Data Is Associated with Increased Citation Rate},\n  "\
                         "journal = {{PLoS} {ONE}},\n  "\
                         "month_numeric = {3}\n}\n"










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
