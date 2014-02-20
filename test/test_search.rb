require "./lib/cites"
require "test/unit"
 
class TestResponse < Test::Unit::TestCase
 
  def setup
    @search_text = 'Piwowar sharing data increases citation PLOS'
    @doi = '10.1371/journal.pone.0000308'
    @search_result = [{"match"=>true, "doi"=>"10.1371/journal.pone.0000308", 
    				   "text"=>"Piwowar sharing data increases citation PLOS"}]
    @doi_result = {"subtitle" => [],
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
  end
  
  def teardown
    ## Nothing really
  end
 
  def test_links_endpoint
    assert_equal(@search_result, Cites.search(@search_text))
  end

  def test_doi_search_json
  	assert_equal(@doi_result, Cites.doi2cit(@doi, 'citeproc-json')[0])
  end
 
end