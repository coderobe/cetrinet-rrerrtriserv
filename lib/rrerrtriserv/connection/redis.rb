# frozen_string_literal: true

require "redis"

module Rrerrtriserv
  module Connection
    class Redis
      include Singleton

      attr_reader :redis

      def initialize
        @redis = ::Redis.new(url: Rrerrtriserv.config.redis.url)
      end
    end
  end
end
