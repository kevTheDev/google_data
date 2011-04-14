# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "google_data/version"


Gem::Specification.new do |s|
  s.name = %q{google_data}
  s.version = GoogleData::VERSION
  s.date = %q{2010-03-12}
  s.authors = ["Kevin Edwards", "Mike Reich"]
  s.email = %q{kev.j.edwards@gmail.com}
  s.summary = %q{A full featured wrapper for interacting with the Google Data base API}
  s.homepage = %q{http://github.com/kevTheDev/google_data}
  s.description = %q{google_data is a full featured wrapper for version 3.0 of the Google Data API}
  
  s.require_paths = ["lib"]
  
  s.add_dependency 'hpricot',    '>= 0.8.4'
  
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'forgery'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'i18n'
end