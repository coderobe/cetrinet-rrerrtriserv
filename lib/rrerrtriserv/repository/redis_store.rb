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

      mediate :ping
      mediate :hewwo
      mediate :perish
      mediate :add_connection
      mediate :del_connection
      mediate :authenticate_client
      mediate :authenticated?
      mediate :client_name
      mediate :subscribe_client
      mediate :publish
      mediate :channel_create
      mediate :channel_list
      mediate :channel_join
      mediate :channel_part
      mediate :channel_user_list
      mediate :channel_has_user?
      mediate :redis_info
    end
  end
end
