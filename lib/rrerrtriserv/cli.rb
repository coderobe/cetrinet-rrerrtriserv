# frozen_string_literal: true

require "thor"

require "rrerrtriserv/commands/start"

module Rrerrtriserv
  class CLI < Thor
    desc "start", "Start the WebSocket-based server"
    def start
      Commands::Start.new.run
    end
  end
end
