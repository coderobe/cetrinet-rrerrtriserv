# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rrerrtriserv/version"

Gem::Specification.new do |spec|
  spec.name          = "rrerrtriserv"
  spec.version       = Rrerrtriserv::VERSION
  spec.authors       = ["Georg Gadinger"]
  spec.email         = ["nilsding@nilsding.org"]

  spec.summary       = "The rrerrNet tetris server"
  spec.description   = "The rrerrNet tetris server.  Name is subject to change."
  spec.homepage      = "https://github.com/rrerrnet/rrerrtriserv"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "confstruct", "~> 1.0"
  spec.add_dependency "connection_pool", "~> 2.2"
  spec.add_dependency "msgpack", "~> 1.2"
  spec.add_dependency "receptacle", "~> 0.3"
  spec.add_dependency "redis", "~> 4.0"
  spec.add_dependency "reel", "~> 0.6"
  spec.add_dependency "thor", "~> 0.20"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rt_rubocop_defaults", "~> 1.0"
  spec.add_development_dependency "rubocop", "~> 0.53"
end
