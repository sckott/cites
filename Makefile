all:
		gem build cites.gemspec && gem install cites-0.0.1.gem
		thor install Thorfile --force