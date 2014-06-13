cites
======

**this is alpha software, so expect changes**

## What is it?  

__`cites` has two main tasks:__ 

* Search for a paper. Uses the CrossRef Metadata Search API, which allows POST requests of free form text. 
* Get a citation from a DOI. Uses CrossRef [citation formatting service](http://labs.crossref.org/citation-formatting-service/) to search for citation information.

Each of the two above tasks are functions that you can use within Ruby, and are available from the command line/terminal so that you don't have to spin up Ruby. This latter use case we think is really powerful. That is, during a typical writing workflow (in which you are using bibtex formatted references) one can want a citation for their paper, and instead of opening up a browser and using Google Scholar or Web of Science, etc., you can quickly search in your terminal by doing e.g., `cite search 'keywords that will help find the paper, including author, year, etc.'`. Which if matches will give you a DOI. Then you can do `thor cite get DOI | pbcopy` and you get the bibtex reference in your clipboard. Then just paste into your bibtex file or references manager. See more examples below.

## Dependencies

* `HTTParty` gem to make web calls to Crossref APIs
* `bibtex-ruby` gem to parse the bibtex
* `json` gem to convert to/from JSON
* `thor` gem to do `cites` stuff on the command line
* `bundler`
* `rake`
* `api_cache`
* `moneta`
* `launchy`

## Contributors

* Scott Chamberlain
* Joona Lehtomäki

## Changes

For changes see the [NEWS file](https://github.com/sckott/cites/blob/master/NEWS.md). 

## Quickstart

### Install

#### Release version

Install latest release from from [RubyGems](https://rubygems.org/gems/cites)

```
gem install cites
```

#### Development version

Install dependencies

```
gem install httparty bibtex-ruby launchy json rake api_cache moneta
sudo gem install thor
sudo gem install bundler
git clone https://github.com/sckott/cites.git
cd cites
bundle install
```

After `bundle install` the `cites` gem is installed and available on the command line or in a Ruby repl. 

### Command line 

I decided to use [Thor](http://whatisthor.com/) to make functions within `cites` available on the cli. Thor is cool. For example, you can list the commands available like

```
cite
```

```
Commands:
  cite get citation    # Get a citation from a DOI
  cite help [COMMAND]  # Describe available commands or one specific command
  cite launch paper    # Open a paper from a given DOI in your default browser
  cite match STRING    # Look for matches in free form citations, get a match and DOI
  cite search STRING   # Search for articles via query string or DOI
```

Get help for a particular method

```
cite help get
```

```
Usage:
  cite get citation

Options:
  [--format=FORMAT]
                     # Default: text
  [--style=STYLE]
                     # Default: apa
  [--locale=LOCALE]
                     # Default: en-US
  [--cache=CACHE]
                     # Default: true

Get a citation from a DOI
```

This is what's associated with `cites` from the cli.

Other commands are available, just type `cite` on the cli, and press enter. 

### Match to free form citations for a paper

From the CLI

```
cite search 'Piwowar sharing data increases citation PLOS'
```

```
Searching with query 'Piwowar sharing data increases citation PLOS'

  Title: Sharing Detailed Research Data Is Associated with Increased Citation Rate
  Year: 2007
  Normalized score: 100
  DOI: http://dx.doi.org/10.1371/journal.pone.0000308

  Title: Sharing Detailed Research Data Is Associated with Increased Citation Rate
  Year: 2007
  Normalized score: 98
  DOI: http://dx.doi.org/10.1038/npre.2007.361.1

  Title: Sharing Detailed Research Data Is Associated with Increased Citation Rate
  Year: 2007
  Normalized score: 98
  DOI: http://dx.doi.org/10.1038/npre.2007.361

...cutoff
```

And you can do many searches, separated with commas, like

```
cite search 'Piwowar sharing data increases citation PLOS,boettiger Modeling stabilizing selection'
```

Search within Ruby

```ruby
require 'cites'
Cites.search('Piwowar sharing data increases citation PLOS')
```

```ruby
=> {"meta"=>
  {"totalResults"=>872393,
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

...cutoff
```

### Metadata search

This is searching the metadata for articles, not matching citations as in the last example. This uses the CrossRef metadata search API, at the `/dois` endpoint documented here: http://search.crossref.org/help/api

From the CLI

```
cite search 'ecology' --rows=5
```

```
Searching with query 'ecology'

  Title: Fire Ecology
  Year:
  Normalized score: 100
  DOI: http://dx.doi.org/10.4996/fireecology

  Title: ISRN Ecology
  Year:
  Normalized score: 100
  DOI: http://dx.doi.org/10.5402/ecology

  Title: ISRN Ecology
  Year:
  Normalized score: 100
  DOI: http://dx.doi.org/10.1155/8641

  Title: Marine Ecology
  Year:
  Normalized score: 88
  DOI: http://dx.doi.org/10.1111/(issn)1439-0485

  Title: Functional Ecology
  Year:
  Normalized score: 88
  DOI: http://dx.doi.org/10.1111/(issn)1365-2435
```

```
cite search 'ecology,birds' --rows=5
```

```
Searching with query 'ecology,birds'

  Title: Population Ecology if Migratory Birds (Symposium)
  Year: 1974
  Normalized score: 100
  DOI: http://dx.doi.org/10.2307/1935170

  Title: Raptors and other soaring birds
  Year: 2007
  Normalized score: 98
  DOI: http://dx.doi.org/10.1016/b978-012517367-4.50007-3

  Title: Glossary
  Year: 2007
  Normalized score: 98
  DOI: http://dx.doi.org/10.1016/b978-012517367-4.50029-2

  Title: References
  Year: 2007
  Normalized score: 98
  DOI: http://dx.doi.org/10.1016/b978-012517367-4.50030-9

  Title: References
  Year: 2001
  Normalized score: 98
  DOI: http://dx.doi.org/10.1016/b978-012675555-8/50008-7
```

From within Ruby

```ruby
Cites.search('palmer')
```

```ruby
=> {"meta"=>
  {"totalResults"=>47552,
   "startIndex"=>0,
   "itemsPerPage"=>10,
   "query"=>{"searchTerms"=>"palmer", "startPage"=>1}},
 "items"=>
  [{"doi"=>"http://dx.doi.org/10.5270/oceanobs09.cwp.68",
    "normalizedScore"=>100,
    "title"=>"Future Observations for Monitoring Global Ocean Heat Content",
    "year"=>"2010"},
   {"doi"=>"http://dx.doi.org/10.1007/springerreference_4038",
    "normalizedScore"=>93,
    "title"=>"Palmer index",
    "year"=>"2011"},

...cutoff
```


### Get a reference from a DOI

From the CLI, default output is text format, apa style, locale en-US

```
cite get 10.1371/journal.pone.0095361
```

```
Samson, D. R., & Hunt, K. D. (2014). Chimpanzees Preferentially Select Sleeping Platform Construction Tree Species with Biomechanical Properties that Yield Stable, Firm, but Compliant Nests. PLoS ONE, 9(4), e95361. doi:10.1371/journal.pone.0095361
```

You can pass in options to the call on the cli, like here choose `ris` for the format

```
cite get 10.1371/journal.pone.0095361 --format=ris
```

```
TY  - JOUR
DO  - 10.1371/journal.pone.0095361
UR  - http://dx.doi.org/10.1371/journal.pone.0095361
TI  - Chimpanzees Preferentially Select Sleeping Platform Construction Tree Species with Biomechanical Properties that Yield Stable, Firm, but Compliant Nests
T2  - PLoS ONE
AU  - Samson, David R.
AU  - Hunt, Kevin D.
PY  - 2014
DA  - 2014/04/16
PB  - Public Library of Science (PLoS)
SP  - e95361
IS  - 4
VL  - 9
SN  - 1932-6203
ER  -
```

And here `bibtex` for the format

```
cite get 10.1371/journal.pone.0095361 --format=bibtex
```

```
@article{Samson_2014,
  title = {Chimpanzees Preferentially Select Sleeping Platform Construction Tree Species with Biomechanical Properties that Yield Stable, Firm, but Compliant Nests},
  volume = {9},
  issn = {1932-6203},
  url = {http://dx.doi.org/10.1371/journal.pone.0095361},
  doi = {10.1371/journal.pone.0095361},
  number = {4},
  journal = {PLoS ONE},
  publisher = {Public Library of Science (PLoS)},
  author = {Samson, David R. and Hunt, Kevin D.},
  editor = {Brosnan, Sarah FrancesEditor},
  year = {2014},
  month = {apr},
  pages = {e95361}
}
```

Two more options, `style` and `locale` are only available with text format, like

```
cite get 10.1371/journal.pone.0095361 --format=text --style=mla --locale=fr-FR
```

```
Samson, David R., et Kevin D. Hunt. « Chimpanzees Preferentially Select Sleeping Platform Construction Tree Species with Biomechanical Properties that Yield Stable, Firm, but Compliant Nests ». Éd. par Sarah Frances Brosnan. PLoS ONE 9.4 (2014): e95361. CrossRef. Web.
```

Within Ruby

```ruby
require 'cites'
Cites.doi2cit('10.1371/journal.pone.0000308')
```

```ruby
=> ["Piwowar, H. A., Day, R. S., & Fridsma, D. B. (2007). Sharing Detailed Research Data Is Associated with Increased Citation Rate. PLoS ONE, 2(3), e308. doi:10.1371/journal.pone.0000308\n"]
```

### Open paper in browser

Uses [Macrodocs](http://macrodocs.org/). The default, using Macrodocs, only works for open access (#OA) articles. You can set the option `oa` to be false. 

```
cite launch '10.1371/journal.pone.0000308'
```

```
# launches in your default browser with url http://macrodocs.org/?doi=10.1371/journal.pone.0000308
```

It's super simple, it just concatenates your DOI onto `http://macrodocs.org/?doi=` to give in this case [http://macrodocs.org/?doi=10.1371/journal.pone.0000308](http://macrodocs.org/?doi=10.1371/journal.pone.0000308) for what you will get from that command. 

When you don't have an open access article, set the oa option flag to false, like `--oa=false`

```
cite launch '10.1111/1365-2745.12157' --oa=false
```

```
# launches in your default browser with url http://dx.doi.org/10.1371/journal.pone.0000308
```

Setting `--oa=false` simply concatenates your doi onto `http://dx.doi.org/`, which then attempts to resolve to likely the publishers page for the article.

## Video

__Asciicast video [here](http://asciinema.org/a/7261)__

## To do

* Add parameter for citation format, right now only gives back bibtex. Crossref API will give back many different formats though. 
* Add other Crossref metadata search functions. 
