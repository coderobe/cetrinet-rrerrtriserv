# frozen_string_literal: true

require "eventmachine"
require "websocket"
require "websocket-eventmachine-server"

require "rrerrtriserv/use_case/send_motd"

module Rrerrtriserv
  module Commands
    class Start
      def run
        Rrerrtriserv.logger.info RUBY_DESCRIPTION
        Rrerrtriserv.logger.info "Starting EventMachine..."
        EM.run do
          start_websocket_server
        end
      end

      private

      def start_websocket_server
        WebSocket::EventMachine::Server.start(host: "0.0.0.0", port: 8080) do |ws|
          ws.onopen do
            Rrerrtriserv.logger.info "Client connected"
            Rrerrtriserv::UseCase::SendMotd.new(ws: ws).run
          end

          ws.onmessage do |msg, type|
            Rrerrtriserv.logger.debug "Received message: #{msg.inspect}, #{type.inspect}"
          end

          ws.onclose do
            Rrerrtriserv.logger.info "Client disconnected"
          end
        end
      end
    end
  end
end
