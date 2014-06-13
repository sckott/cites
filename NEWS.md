## CHANGES IN VERSION 0.1.2 (2014-06-13)

### Minor changes

+ Add CLI coloration using Thor
+ Installation instructions in the README updated to include installation from RubyGems

## CHANGES IN VERSION 0.1.0 (2014-04-19)

### Major changes

#### Development system overhaul

+ `cites` gem development now uses [bundler](http://bundler.io/) for tracking and managing dependencies.
+ `cites` gem development now uses [rake](http://rake.rubyforge.org/) to manage different development tasks such as testing and building.
+ Old `Makefile` has been removed.
+ Installation instructions now look like this:

    __Dependencies__ 

    Install packages needed for development, e.g. on Ubuntu:
    
    ```
    sudo apt-get install git ruby ruby-dev
    ```

    Install bundler

    ```
    sudo gem install bundler
    ```

    Get the sources for `cites`

    ```
    git clone https://github.com/sckott/cites.git
    cd cites
    ```

    Install dependencies using bundler

    ```
    bundle install
    ```
    
    Note that on a multicore system you can also use > 1 cores with bundler, e.g.
    
    
    ```
    # Uses 4 cores
    bundle install -j4
    ```
    
    __Install system-wide using Rake__

    Since `rake` is included in the dependencies, the build system should be available after the previous step. To install `cites` system wide:
    
    ```
    sudo rake install
    ```
    
    Other tasks include e.g.
    
    ```
    # Run tests
    rake test
    # Build the gem
    rake build
    # Create a tag on GitHub with the version of the gem, push the locally committed 
    # files to the master on GitHub and publish the gem on RubyGems.org. 
    # Remember, commit your changes, before run this task.
    rake release
    ```

#### Code architecture and CLI

+ `Cites` is no longer a class, but a module. In practice, very little has changed and most code work without changes. All methods in class `Cites` were bascially class methods and the class itself isn't being instantiated anywhere, so a module seems like a better fit. Modules can be seen as [especially suitable for libraries](https://stackoverflow.com/questions/151505/difference-between-a-class-and-a-module) which does suit `Cites`.
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
