# frozen_string_literal: true

require "socket"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/part_user"
require "rrerrtriserv/use_case/concerns/authentication"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    class Disconnect < Base
      include Concerns::Authentication
      include Concerns::WebSocket

      def run
        Rrerrtriserv.logger.info "Client #{peer_to_s} disconnected"
        part_from_all_channels
        Rrerrtriserv::Repository::RedisStore.publish(topic: "internal.punsub.#{peer_to_s}", content: {})
        Rrerrtriserv::Repository::RedisStore.del_connection(peer: peer_to_s)
      end

      private

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
    end
  end
end
