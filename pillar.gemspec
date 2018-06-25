lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pillar/version"

Gem::Specification.new do |spec|
  spec.name          = "pillar"
  spec.version       = Pillar::VERSION
  spec.authors       = ["Olov Jacobsen"]
  spec.email         = ["olle@ojacobsen.se"]

  spec.summary       = "pillar..."
  spec.description   = "pillar..."
  spec.homepage      = "https://github.com/olojac/"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + Dir["bin/*"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.2"
  spec.add_development_dependency "activemodel",      ">= 4.2"
  spec.add_development_dependency "actionview",       ">= 4.2"
  spec.add_development_dependency "actionpack",       ">= 4.2"
  spec.add_development_dependency "minitest",         "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
end
