# frozen_string_literal: true

require "bundler/setup"
require "rrerrtriserv"

require "receptacle/test_support"

require_relative "support/auth_helpers"
require_relative "support/matchers"
require_relative "support/redis"
require_relative "support/reel_web_socket_client"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Receptacle::TestSupport

  # Log to a file instead of stdout
  Rrerrtriserv.instance_variable_set("@logger", ::Logger.new(File.expand_path("../test.log", __dir__)))
end
