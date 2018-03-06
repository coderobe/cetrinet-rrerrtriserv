# frozen_string_literal: true

require "receptacle"

require "rrerrtriserv/repository/redis_store/strategy/redis"
require "rrerrtriserv/repository/redis_store/wrapper/logger"

module Rrerrtriserv
  module Repository
    module RedisStore
      include Receptacle::Repo

      strategy Rrerrtriserv::Repository::RedisStore::Strategy::Redis
      wrappers [Rrerrtriserv::Repository::RedisStore::Wrapper::Logger]

      mediate :hewwo
      mediate :perish
      mediate :add_connection
      mediate :del_connection
      mediate :authenticate_client
    end
  end
end
