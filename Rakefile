require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "brighter_planet_layout"
    gem.summary = %Q{Layout assets for Brighter Planet sites}
    gem.description = %Q{Layouts, partials, stylesheets, and images}
    gem.email = "andy@rossmeissl.net"
    gem.homepage = "http://github.com/brighterplanet/brighter_planet_layout"
    gem.authors = ["Andy Rossmeissl", "Seamus Abshere"]
    gem.add_dependency 'ultraviolet', '>=0.10.2'
    gem.add_dependency 'simple-rss', '>=1.2.3'
    gem.files.reject! { |fn| fn.downcase =~ /\.ai$/ }
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "brighter_planet_layout #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
