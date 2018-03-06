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
  spec.add_dependency "eventmachine", "~> 1.2"
  spec.add_dependency "msgpack", "~> 1.2"
  spec.add_dependency "receptacle", "~> 0.3"
  spec.add_dependency "redis", "~> 4.0"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "websocket", "~> 1.2"
  spec.add_dependency "websocket-eventmachine-server", "~> 1.0"
  spec.add_dependency "websocket-native", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rt_rubocop_defaults", "~> 1.0"
  spec.add_development_dependency "rubocop", "~> 0.53"
end
