## CHANGES IN VERSION 0.0.2 (2014-02-xx)

+ `doi2cit` now parses json response (citeproc-json) into valid Ruby hashes
+ Error handling for DOI resolution added to `doi2cit`
+ Add tests
+ `Cites.getcite()`  has now cache capabilities implemented using `api_cache`
    * Default cache location is at `~/.cites/cache` as defined by class variable `Cites::cache_location`
    * Result are cached using SHA1 hash generated from DOI and content type
    * Because DOIs are supposed to be immutable data in the cache will never expire
    * Cache can be bypassed completely by providing argument `cache=false` to `getcite()`
    * Cache can be flushed (i.e. old cache content removed and replaced with fresh content) providing argument `cache='flush'` to `getcite()`
+ bibtex content is returned as a String by `getcite()`
