$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "realtime-validations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "realtime-validations"
  s.version     = RealtimeValidations::VERSION
  s.authors     = ["Rafael Fernández López"]
  s.email       = ["ereslibre@gmail.com"]
  s.homepage    = "http://www.ereslibre.es/"
  s.summary     = "Provides real time validations for free"
  s.description = "Form real time validations for free on Rails applications"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.3"

  s.add_development_dependency "sqlite3"
end
