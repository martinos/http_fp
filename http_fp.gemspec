# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_fp/version'

Gem::Specification.new do |spec|
  spec.name          = "http_fp"
  spec.version       = HttpFp::VERSION
  spec.authors       = ["Martin Chabot"]
  spec.email         = ["chabotm@gmail.com"]
  spec.summary       = %q{Http client that levrage the use of fp principle}
  spec.description   = %q{Http client that levrage the use of fp principle}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "minitest"
  spec.add_dependency "rake", "~> 10.0"
  spec.add_dependency "activesupport"
  spec.add_dependency "superators19"
end
