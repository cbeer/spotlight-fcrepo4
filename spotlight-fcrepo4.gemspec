$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spotlight/fcrepo4/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spotlight-fcrepo4"
  s.version     = "0.0.1"
  s.authors     = ["Chris Beer"]
  s.email       = ["cabeer@stanford.edu"]
  s.homepage    = "https://github.com/cbeer/spotlight-fcrepo4"
  s.summary     = "Store Spotlight exhibit data in Fedora 4"
  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency "blacklight", ">= 5.4.0.rc1", "<6"
  s.add_dependency "spotlight"
  s.add_dependency "activeresource-ldp"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist", ">= 1.5.0"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "engine_cart", "~> 0.3.4"
  s.add_development_dependency "database_cleaner", "< 1.1.0"
  s.add_development_dependency "jettywrapper"
end
