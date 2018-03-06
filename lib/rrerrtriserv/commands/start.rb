# frozen_string_literal: true

require "eventmachine"
require "websocket"
require "websocket-eventmachine-server"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/connect"
require "rrerrtriserv/use_case/disconnect"
require "rrerrtriserv/use_case/receive"
require "rrerrtriserv/use_case/send_error"

module Rrerrtriserv
  module Commands
    class Start
      def run
        Rrerrtriserv::Repository::RedisStore.hewwo
        at_exit do
          Rrerrtriserv::Repository::RedisStore.perish
        end

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
            Rrerrtriserv::UseCase::Connect.new(ws: ws).run
          end

          ws.onmessage do |msg, type|
            Rrerrtriserv.logger.debug "Received message: #{msg.inspect}, #{type.inspect}"
            begin
              Rrerrtriserv::UseCase::Receive.new(ws: ws, msg: msg).run
            rescue StandardError => e
              Rrerrtriserv::UseCase::SendError.new(ws: ws, error: e).run
            end
          end

          ws.onclose do
            Rrerrtriserv::UseCase::Disconnect.new(ws: ws).run
          end
        end
      end
    end
  end
end
