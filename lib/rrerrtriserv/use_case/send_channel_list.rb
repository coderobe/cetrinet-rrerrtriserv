# frozen_string_literal: true

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendChannelList < Send
      def type
        "channellist"
      end

      def data
        {
          c: channels
        }
      end

      private

      def channels
        Rrerrtriserv::Repository::RedisStore.channel_list.map do |channel|
          {
            n: channel,
            u: Rrerrtriserv::Repository::RedisStore.channel_user_list(channel_name: channel).count
          }
        end
      end
    end
  end
end
