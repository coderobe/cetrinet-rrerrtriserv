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
        Rrerrtriserv.logger.info RUBY_DESCRIPTION

        check_redis!

        Rrerrtriserv::Repository::RedisStore.hewwo
        at_exit do
          Rrerrtriserv::Repository::RedisStore.perish
        end

        create_default_channel

        Rrerrtriserv.logger.info "Starting EventMachine..."
        EM.run do
          Signal.trap("INT") do
            puts " * received SIGINT, time to say goodbye!"
            EM.stop
          end

          start_websocket_server
        end
      end

      private

      def check_redis!
        Rrerrtriserv::Repository::RedisStore.ping
      rescue StandardError => e
        abort(
          "\033[31;1mAn error occurred while trying to connect to Redis\033[0m\n"\
          "\033[1m#{e.class.name}\033[0m: #{e.message}"
        )
      end

      def create_default_channel
        Rrerrtriserv::Repository::RedisStore.channel_create(
          channel_name: Rrerrtriserv.config.default_channel
        )
      end

      def start_websocket_server
        WebSocket::EventMachine::Server.start(
          host: Rrerrtriserv.config.server.host,
          port: Rrerrtriserv.config.server.port
        ) do |ws|
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
