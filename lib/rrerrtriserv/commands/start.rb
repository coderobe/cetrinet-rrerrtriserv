# frozen_string_literal: true

require "eventmachine"
require "websocket"
require "websocket-eventmachine-server"

require "rrerrtriserv/use_case/receive"

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
            Rrerrtriserv.logger.info "Client connected, waiting for auth..."
          end

          ws.onmessage do |msg, type|
            Rrerrtriserv.logger.debug "Received message: #{msg.inspect}, #{type.inspect}"
            Rrerrtriserv::UseCase::Receive.new(ws: ws, msg: msg).run
          end

          ws.onclose do
            Rrerrtriserv.logger.info "Client disconnected"
          end
        end
      end
    end
  end
end
