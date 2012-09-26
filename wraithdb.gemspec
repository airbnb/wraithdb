# -*- encoding: utf-8 -*-
require File.expand_path('../lib/wraithdb/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nathan Baxter"]
  gem.email         = ["nathan.baxter@airbnb.com"]
  gem.description   = %q{WraithDB uses schema.rb as a template to initialize ActiveRecord classes when databases are offline. It does this with minimal overhead, leaving the normal connection object untouched and only interacting with the columns and tables interfaces.}
  gem.summary       = %q{Allows Rails to boot in the absence of a working database.}
  gem.homepage      = "https://github.com/airbnb/wraithdb"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "wraithdb"
  gem.require_paths = ["lib"]
  gem.version       = Wraithdb::VERSION
  gem.add_runtime_dependency 'activerecord', '>= 3.0', '<= 3.2'
end
