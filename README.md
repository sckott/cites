cites
======

**this is alpha software, so expect changes**

## What it is?  

__cites does two things:__ 

* Search for a paper. Uses the CrossRef Metadata Search API, which allows POST requests of free form text. 
* Get a citation from a DOI. Uses CrossRef [citation formatting service](http://labs.crossref.org/citation-formatting-service/) to search for citation information.

Each of the two above tasks are functions that you can use within Ruby, and are available from the command line/terminal so that you don't have to spin up Ruby. This latter use case I think is really powerful. That is, during a typical writing workflow (in which you are using bibtex formatted references) one can want a citation for their paper, and instead of opening up a browser and using Google Scholar or Web of Science, etc., you can quickly search in your terminal by doing e.g., `thor cite:search 'keywords that will help find the paper, including author, year, etc.'`. Which if matches will give you a DOI. Then you can do `thor cite:get DOI/string | pbcopy` and you get the bibtex reference in your clipboard. Then just paste into your bibtex file or references manager. See more examples below.

## Dependencies

* `HTTParty` gem to make web calls to Crossref APIs
* `bibtex-ruby` gem to parse the bibtex
* `json` gem to convert to/from JSON
* `thor` gem to do `cites` stuff on the command line

## Quickstart

### Install 

Install dependencies

```
gem install httparty bibtex-ruby launchy
sudo gem install thor
```

```
git clone git@github.com:sckott/cites.git
cd cites
make
```

Running `make` will buil and install the gem, and install options into Thor so that you can do citation stuff from the cli or within Ruby. 

### Thor

I decided to use [Thor](http://whatisthor.com/) to make functions within `cites` available on the cli. Thor is cool. For example, you can list the commands available like

```
thor list
```

```
cites
-----
thor cite:get        # Get a citation from a DOI
thor cite:launch paper   # Open a paper from a given DOI in your default browser
thor cite:search STRING  # Get a DOI from a search string
```

Get help for a particular method

```
thor help cite:get
```

```
Usage:
  thor cite:get

Options:
  [--format=FORMAT]
                     # Default: text
  [--style=STYLE]
                     # Default: apa
  [--locale=LOCALE]
                     # Default: en-US

Get a citation from a DOI
```

This is what's associated with `cites` from the cli using Thor.

Other commands are available, just type `thor` on the cli, and press enter. 

### Search for a paper 

From the CLI

```
thor cite:search 'Piwowar sharing data increases citation PLOS'
```

```
{"match"=>true, "doi"=>"10.1371/journal.pone.0000308", "text"=>"Piwowar sharing data increases citation PLOS"}
```

And you can do many searches, separated with commas, like

```
thor cite:search 'Piwowar sharing data increases citation PLOS,boettiger Modeling stabilizing selection'
```

Search within Ruby

```ruby
require 'cites'
cites.search('Piwowar sharing data increases citation PLOS')
```

```ruby
[{"match"=>true, "doi"=>"10.1371/journal.pone.0000308", "text"=>"Piwowar sharing data increases citation PLOS"}]=> nil
```

### Get a reference from a DOI

From the CLI, default output is text format, apa style, locale en-US

```
thor cite:get '10.1186/1471-2105-14-16'
```

```
Boyle, B., Hopkins, N., Lu, Z., Raygoza Garay, J. A., Mozzherin, D., Rees, T., Matasci, N., et al. (2013). The taxonomic name resolution service: an online tool for automated standardization of plant names. BMC Bioinformatics, 14(1), 16. Springer (Biomed Central Ltd.). doi:10.1186/1471-2105-14-16
```

Because we're using [thor](http://whatisthor.com/) you can pass in options to the call on the cli, like here choose `ris` for the format

```
thor cite:get '10.1371/journal.pone.0000308' --format=ris
```

```
TY  - JOUR
T2  - PLoS ONE
AU  - Piwowar, Heather A.
AU  - Day, Roger S.
AU  - Fridsma, Douglas B.
SN  - 1932-6203
TI  - Sharing Detailed Research Data Is Associated with Increased Citation Rate
SP  - e308
VL  - 2
PB  - Public Library of Science
DO  - 10.1371/journal.pone.0000308
PY  - 2007
UR  - http://dx.doi.org/10.1371/journal.pone.0000308
ER  -
```

And here `bibtex` for the format

```
thor cite:get '10.1371/journal.pone.0000308' --format=bibtex
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

Two more options, `style` and `locale` are only available with text format, like

```
thor cite:get '10.1371/journal.pone.0000308' --format=text --style=mla --locale=fr-FR
```

```
Piwowar, Heather A., Roger S. Day, et Douglas B. Fridsma. « Sharing Detailed Research Data Is Associated with Increased Citation Rate ». éd par. John Ioannidis. PLoS ONE 2.3 (2007): e308.
```

Within Ruby

```ruby
require 'cites'
cites.doi2cit('10.1371/journal.pone.0000308')
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

### Open paper in browser

Uses [Macrodocs](http://macrodocs.org/). The default, using Macrodocs, only works for open access (#OA) articles. You can set the option `oa` to be false. 

```
thor cite:launch '10.1371/journal.pone.0000308'
```

```
# launches in your default browser with url http://macrodocs.org/?doi=10.1371/journal.pone.0000308
```

It's super simple, it just concatenates your DOI onto `http://macrodocs.org/?doi=` to give in this case [http://macrodocs.org/?doi=10.1371/journal.pone.0000308](http://macrodocs.org/?doi=10.1371/journal.pone.0000308) for what you will get from that command. 

When you don't have an open access article, set the oa option flag to false, like `--oa=false`

```
thor cite:launch '10.1111/1365-2745.12157' --oa=false
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
