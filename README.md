doiref
======

Get bibtex, other format citations from a DOI.

Uses the CrossRef [citation formatting service](http://labs.crossref.org/citation-formatting-service/) to search for the citation information.

Uses HTTParty gem to make web API calls

Uses bibtex-ruby gem to parse the bibtex

You can run it from the CLI or within Ruby. 

From the CLI

```
doiref 10.1186/1471-2105-14-16

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
require 'DOIref'
DOIref.lookup_bib('10.1371/journal.pone.0000308')

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