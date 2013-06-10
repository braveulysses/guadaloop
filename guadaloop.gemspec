# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guadaloop/version'

Gem::Specification.new do |spec|
  spec.name          = "guadaloop"
  spec.version       = Guadaloop::VERSION
  spec.authors       = ["Jacob Childress"]
  spec.email         = ["jacobc@gmail.com"]
  spec.description   = %q{Client for the node-gtfs transit data API.}
  spec.summary       = %q{A client library for the node-gtfs example application's transit data API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'geocoder'
  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'thor'
end
