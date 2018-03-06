# frozen_string_literal: true

require "socket"
require "msgpack"

require "rrerrtriserv/connection/redis"

module Rrerrtriserv
  module Repository
    module RedisStore
      module Strategy
        class Redis
          def hewwo
            Rrerrtriserv.logger.debug "saying hewwo to redis"
            redis.sadd("processes", ident)
            redis.del(connections_key)
          end

          def perish
            Rrerrtriserv.logger.debug "saying goodbye to redis"
            redis.srem("processes", ident)
            redis.del(connections_key)
          end

          def add_connection(peer:)
            redis.hset(connections_key, peer, pack(authenticated: false))
          end

          def del_connection(peer:)
            redis.hdel(connections_key, peer)
          end

          def authenticate_client(peer:, name:, client:)
            hash = unpack(redis.hget(connections_key, peer))
            hash.merge("authenticated" => true, "name" => name, "client" => client)
            redis.hset(connections_key, peer, pack(hash))
          end

          private

          def redis
            Rrerrtriserv::Connection::Redis.instance.redis
          end

          def ident
            hostname = Socket.gethostname
            "#{hostname}:#{$$}"
          end

          def connections_key
            "#{ident}:connections"
          end

          def pack(payload)
            MessagePack.pack(payload)
          end

          def unpack(payload)
            MessagePack.unpack(payload)
          end
        end
      end
    end
  end
end
