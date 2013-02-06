# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sabre/version'

Gem::Specification.new do |gem|
  gem.name          = "sabre"
  gem.version       = Sabre::VERSION
  gem.authors       = ["Luke Curley"]
  gem.email         = ["qpingu@gmail.com"]
  gem.description   = %q{Deployment DSL that translates into bash}
  gem.summary       = %q{Deployment DSL that translates into bash}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "blockenspiel"
  gem.add_dependency "voke"
end
