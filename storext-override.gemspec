$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "storext/override/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "storext-override"
  s.version     = Storext::Override::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of StorextOverride."
  s.description = "TODO: Description of StorextOverride."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.1.5"
  s.add_dependency "storext"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
