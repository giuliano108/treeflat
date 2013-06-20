# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'treeflat/version'

Gem::Specification.new do |gem|
  gem.name          = "treeflat"
  gem.version       = TreeFlat::VERSION
  gem.authors       = ["Giuliano Cioffi"]
  gem.email         = ["giuliano@108.bz"]
  gem.description   = %q{Flatten nested hash/array structures into tables}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
