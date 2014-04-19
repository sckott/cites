all: install
		
install:
		gem build cites.gemspec && gem install cites-0.0.2.gem
