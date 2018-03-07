# frozen_string_literal: true

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendUserList < Send
      def type
        "userlist"
      end

      def data
        {
          c: channel_name,
          u: users
        }
      end

      private

      def channel_name
        dto.fetch(:channel_name)
      end

      def users
        Rrerrtriserv::Repository::RedisStore.channel_user_list(
          channel_name: channel_name
        )
      end
    end
  end
end
