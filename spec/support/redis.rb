# frozen_string_literal: true

# Convenience helpers for Redis connections

require "rrerrtriserv/connection/redis"
require "rrerrtriserv/repository/redis_store/strategy/redis"

def with_redis(&block)
  Rrerrtriserv::Connection::Redis.instance.redis.with(&block)
end

def redis_test_ident
  "testing.local:1337"
end

def redis_test_base_pubsub_key
  "rrerrtriserv-test"
end

Rrerrtriserv::Repository::RedisStore::Strategy::Redis::BASE_PUBSUB_KEY = redis_test_base_pubsub_key

RSpec.configure do |config|
  config.before(:each) do
    # mock repository ident
    allow_any_instance_of(Rrerrtriserv::Repository::RedisStore::Strategy::Redis)
      .to receive(:ident).and_return(redis_test_ident)

    # clear redis state and send internal unsubscribe topic
    with_redis do |redis|
      redis.srem("processes", redis_test_ident)
      redis.del("channels")
      redis.del("#{redis_test_ident}:connections")
      redis.publish("#{redis_test_base_pubsub_key}.internal.punsub.127.1.0.1:54321", "")
    end
  end
end
