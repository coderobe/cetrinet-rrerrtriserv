# frozen_string_literal: true

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/send_user_list"
require "rrerrtriserv/use_case/concerns/authentication"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    # when a user /JOINs a channel
    # basically:
    # - add the user to the channel's user list
    # - publish a join event for the channel+user, which will be forwarded to the user
    # - TODO: send the user a list of users in the channel
    class JoinUser < Base
      include Concerns::Authentication
      include Concerns::WebSocket

      def run
        join_channel
        send_user_list
        publish_join
      end

      private

      def join_channel
        Rrerrtriserv::Repository::RedisStore.channel_join(
          user: client_name,
          channel_name: channel_name
        )
      end

      def send_user_list
        Rrerrtriserv::UseCase::SendUserList.new(
          ws: ws,
          channel_name: channel_name
        ).run
      end

      def publish_join
        Rrerrtriserv::Repository::RedisStore.publish(
          topic: "join.#{dto.fetch(:channel_name)}",
          content: { user: client_name }
        )
      end

      def channel_name
        dto.fetch(:channel_name)
      end
    end
  end
end
