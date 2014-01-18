doiref
======

**this is alpha software, so expect changes**

### What it is?  

__doiref does two things:__ 

* Search for a paper. Uses the CrossRef Metadata Search API, which allows POST requests of free form text. 
* Get a citation from a DOI. Uses CrossRef [citation formatting service](http://labs.crossref.org/citation-formatting-service/) to search for citation information.

Each of the two above tasks are functions that you can use within Ruby, and are available from the command line/terminal so that you don't have to spin up Ruby. This latter use case I think is really powerful. That is, during a typical writing workflow (in which you are using bibtex formatted references) one can want a citation for their paper, and instead of opening up a browser and using Google Scholar or Web of Science, etc., you can quickly search in your terminal by doing e.g., `crsearch 'keywords that will help find the paper, including author, year, etc.'`. Which if matches will give you a DOI. Then you can do `doiref DOI/string | pbcopy` and you get the bibtex reference in your clipboard. Then just paste into your bibtex file or references manager. 

### Dependencies

* `HTTParty` gem to make web calls to Crossref APIs
* `bibtex-ruby` gem to parse the bibtex
* `json` gem to convert to/from JSON

### Quickstart

#### Install 

```
git clone git@github.com:sckott/doiref.git
cd doiref
make
```

You can run `doiref` from the command line interface (CLI) or within Ruby. 

#### Search for a paper 

From the CLI

```
crsearch 'Piwowar sharing data increases citation PLOS'
```

```
[{"match"=>true, "doi"=>"10.1371/journal.pone.0000308", "text"=>"Piwowar sharing data increases citation PLOS"}]
```

Within Ruby

```ruby
require 'doiref'
DOIref.search('Piwowar sharing data increases citation PLOS')
```

```ruby
[{"match"=>true, "doi"=>"10.1371/journal.pone.0000308", "text"=>"Piwowar sharing data increases citation PLOS"}]=> nil
```

#### Get a reference from a DOI

From the CLI

```
doiref 10.1186/1471-2105-14-16
```

```
@article{Piwowar_Day_Fridsma_2007,
  title = {Sharing Detailed Research Data Is Associated with Increased Citation Rate},
  volume = {2},
  url = {http://dx.doi.org/10.1371/journal.pone.0000308},
  doi = {10.1371/journal.pone.0000308},
  number = {3},
  journal = {PLoS ONE},
  publisher = {Public Library of Science},
  author = {Piwowar, Heather A. and Day, Roger S. and Fridsma, Douglas B.},
  editor = {Ioannidis, JohnEditor},
  year = {2007},
  month = {mar},
  pages = {e308}
}
```

Within Ruby
```ruby
require 'doiref'
DOIref.doi2cit('10.1371/journal.pone.0000308')
```

```ruby
@article{Piwowar_Day_Fridsma_2007,
  title = {Sharing Detailed Research Data Is Associated with Increased Citation Rate},
  volume = {2},
  url = {http://dx.doi.org/10.1371/journal.pone.0000308},
  doi = {10.1371/journal.pone.0000308},
  number = {3},
  journal = {PLoS ONE},
  publisher = {Public Library of Science},
  author = {Piwowar, Heather A. and Day, Roger S. and Fridsma, Douglas B.},
  editor = {Ioannidis, JohnEditor},
  year = {2007},
  month = {mar},
  pages = {e308}
}
```

### Video

__Asciicast video [here](http://asciinema.org/a/7040)__

### To do

* Add parameter for citation format, right now only gives back bibtex. Crossref API will give back many different formats though. 
* Add other Crossref metadata search functions. 
