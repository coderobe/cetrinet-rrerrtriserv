# frozen_string_literal: true

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/concerns/authentication"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    # when a user /PARTs a channel
    # basically:
    # - remove the user to the channel's user list
    # - publish a part event for the channel+user, which will be forwarded to the user
    class PartUser < Base
      include Concerns::Authentication
      include Concerns::WebSocket

      def run
        part_channel
        publish_part
      end

      private

      def part_channel
        Rrerrtriserv::Repository::RedisStore.channel_part(
          user: user,
          channel_name: channel_name
        )
      end

      def publish_part
        Rrerrtriserv::Repository::RedisStore.publish(
          topic: "part.#{channel_name}",
          content: { user: user }
        )
      end

      def channel_name
        dto.fetch(:channel_name)
      end

      # needed because the websocket might not be available anymore
      def user
        dto.fetch(:user) { client_name }
      end
    end
  end
end
