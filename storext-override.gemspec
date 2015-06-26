$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "storext/override/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "storext-override"
  s.version     = Storext::Override::VERSION
  s.authors     = ["G5", "Ramon Tayag", "JP Moral"]
  s.email       = ["la.team@g5search.com", "ramon.tayag@gmail.com"]
  s.homepage    = "https://github.com/g5/storext-override"
  s.summary     = "Mimic and be able to override another Storext model"
  s.description = "Mimic and be able to override another Storext model"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "storext", ">= 1.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
