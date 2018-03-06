# frozen_string_literal: true

require "connection_pool"
require "redis"
require "singleton"

module Rrerrtriserv
  module Connection
    class Redis
      include Singleton

      attr_reader :redis

      def initialize
        @redis = ConnectionPool.new(size: Rrerrtriserv.config.redis.pool) do
          ::Redis.new(url: Rrerrtriserv.config.redis.url)
        end
      end
    end
  end
end
