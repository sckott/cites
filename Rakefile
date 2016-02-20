require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

desc "Run tests"
task :default => :test

desc "Build cites docs"
task :docs do
	system "yardoc"
end

desc "bundle install"
task :bundle do
  system "bundle install"
end

desc "clean out builds"
task :clean do
  system "ls | grep [0-9].gem | xargs rm"
end

desc "Build cites"
task :build do
	system "gem build cites.gemspec"
end

desc "Install cites"
task :install => [:bundle, :build] do
	system "gem install cites-#{Cites::VERSION}.gem"
end

desc "Release to Rubygems"
task :release => :build do
  system "gem push cites-#{Cites::VERSION}.gem"
end
