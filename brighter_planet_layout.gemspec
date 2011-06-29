# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brighter_planet_layout/version"

Gem::Specification.new do |s|
  s.name        = "brighter_planet_layout"
  s.version     = BrighterPlanet::Layout::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andy Rossmeissl", "Seamus Abshere"]
  s.email       = ["andy@rossmeissl.net"]
  s.homepage    = "http://github.com/brighterplanet/brighter_planet_layout"
  s.summary     = %Q{Layout assets for Brighter Planet sites}
  s.description = %Q{Layouts, partials, stylesheets, and images}

  s.rubyforge_project = "brighter_planet_layout"

  s.files         = `git ls-files`.split("\n").reject { |fn| fn.downcase =~ /\.ai$/ or fn.downcase =~ /\.psd$/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'simple-rss', '>=1.2.3'
  s.add_dependency 'eat'
#  s.add_dependency 'tronprint'
  s.add_development_dependency 'test-unit'
end
