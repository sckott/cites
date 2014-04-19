## CHANGES IN VERSION 0.1.0 (2014-04-19)

### Major changes

#### Development system overhaul

+ `cites` gem development now uses [bundler](http://bundler.io/) for tracking and managing dependencies.
+ `cites` gem development now uses [rake](http://rake.rubyforge.org/) to manage different development tasks such as testing and building.
+ Old `Makefile` has been removed.

#### CLI

+ Old `Thorfile` has been removed. CLI is still based on [thor](http://whatisthor.com/), but the functionality has been incorporated into a command-line script called `cite`.
+ The way `Cites` functionality is called from command line has changed syntax from Thorfile-based to more common Unix CLI format. E.g. searching for a DOI has changed in a following way:
    
    ```
    # Previously  
    thor cite:search 'Piwowar sharing data increases citation PLOS'
    # Now
    cite search 'Piwowar sharing data increases citation PLOS'
    ```

+ Another example is how to get help for an individual function:

    ```
    # Previously  
    thor help cite:get
    # Now
    cite help get
    ```

#### Code architecture



### Minor changes

+ Tests have been fixed with the latest data provided by CrossRef.
+ CLI output provided by `cite search QUERY` improved.

## CHANGES IN VERSION 0.0.2 (2014-02-22)

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
+ `Cites.search()` now accepts an arbitrary hash of arguments, so that now you can pass in args like `search(:query => 'birds', :year => 2009)` instead of having to put in all args to avoid errors. Default arg values are defined within the function insetad of in the function call.