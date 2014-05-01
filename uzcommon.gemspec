$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "uzcommon/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "uzcommon"
  s.version     = Uzcommon::VERSION
  s.authors     = ["Leo Uzon"]
  s.email       = ["leo.uz86@gmail.com"]
  s.homepage    = ""
  s.summary     = "Uzcommon is the common code between several sites that I develop"
  s.description = "Uzcommon is not ready for 3rd party use, for that happen its need to split it in several projects and add better testing."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "debugger"
end
