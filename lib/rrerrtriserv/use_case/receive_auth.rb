# frozen_string_literal: true

require "msgpack"

require "rrerrtriserv/pubsub/client"
require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/send_channel_list"
require "rrerrtriserv/use_case/send_motd"
require "rrerrtriserv/use_case/concerns/authentication"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    class ReceiveAuth < Base
      include Concerns::Authentication
      include Concerns::WebSocket

      def run
        not_authenticated!
        Rrerrtriserv.logger.info "received auth from #{peer_to_s}: #{name.split('#').first} (#{client})"
        authenticate_client
        subscribe_client
        send_motd
        send_channel_list
      end

      def data
        @_data ||= dto.fetch(:data)
      end

      def client
        data["c"]
      end

      def name
        data["n"]
      end

      private

      def authenticate_client
        Rrerrtriserv::Repository::RedisStore.authenticate_client(
          peer: peer_to_s,
          name: name,
          client: client
        )
      end

      def subscribe_client
        Rrerrtriserv::Repository::RedisStore.subscribe_client(
          peer: peer_to_s,
          handler: Rrerrtriserv::Pubsub::Client.new(ws: ws)
        )
      end

      def send_motd
        UseCase::SendMotd.new(ws: ws).run
      end

      def send_channel_list
        UseCase::SendChannelList.new(ws: ws).run
      end
    end
  end
end
