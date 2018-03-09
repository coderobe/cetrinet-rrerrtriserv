# frozen_string_literal: true

require "socket"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/repository/web_socket_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/part_user"

module Rrerrtriserv
  module UseCase
    class Disconnect < Base
      def run
        Rrerrtriserv.logger.info "Client #{peer_to_s} disconnected"
        part_from_all_channels
        Rrerrtriserv::Repository::RedisStore.publish(topic: "internal.punsub.#{peer_to_s}", content: {})
        Rrerrtriserv::Repository::RedisStore.del_connection(peer: peer_to_s)
        # Note: This is a workaround because EventMachine is rubbish.
        Rrerrtriserv::Repository::WebSocketStore.delete(dto.fetch(:ws))
      end

      private

      def peer_to_s
        # Note: This is a workaround because EventMachine is rubbish.
        @_peer_to_s ||= begin
                          ws_data = Rrerrtriserv::Repository::WebSocketStore[dto.fetch(:ws)]
                          return unless ws_data
                          ws_data[:peer]
                        end
      end

      def part_from_all_channels
        user_channels.each do |channel|
          Rrerrtriserv::UseCase::PartUser.new(
            user: client_name,
            channel_name: channel
          ).run
        end
      end

      def user_channels
        @_user_channels ||= Rrerrtriserv::Repository::RedisStore.channel_list.select do |channel|
          Rrerrtriserv::Repository::RedisStore.channel_has_user?(
            channel_name: channel,
            user: client_name
          )
        end
      end

      def client_name
        @_client_name ||= Rrerrtriserv::Repository::RedisStore.client_name(
          peer: peer_to_s
        )
      end
    end
  end
end
