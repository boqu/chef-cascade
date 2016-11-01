# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cascade/version'

Gem::Specification.new do |spec|
  spec.name          = "cascade"
  spec.version       = Cascade::VERSION
  spec.authors       = ["Zachary Schneider"]
  spec.email         = ["ops@boundary.com"]
  spec.summary       = %q{A chef client that facilitates ordered chef runs.}
  spec.description   = %q{A chef client that facilitates ordered chef runs.}
  spec.homepage      = ""
  spec.license       = "Apache License, Version 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'httparty'

  spec.add_development_dependency "rake"
end
