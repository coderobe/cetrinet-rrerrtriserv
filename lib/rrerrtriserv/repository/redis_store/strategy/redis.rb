# frozen_string_literal: true

require "socket"
require "msgpack"

require "rrerrtriserv/connection/redis"

module Rrerrtriserv
  module Repository
    module RedisStore
      module Strategy
        class Redis
          BASE_PUBSUB_KEY = "rrerrtriserv"

          def ping
            redis { |r| r.ping }
          end

          def hewwo
            Rrerrtriserv.logger.debug "saying hewwo to redis"
            redis do |r|
              r.sadd("processes", ident)
              r.del(connections_key)
            end
          end

          def perish
            Rrerrtriserv.logger.debug "saying goodbye to redis"
            redis do |r|
              r.srem("processes", ident)
              r.del(connections_key)
            end
          end

          def add_connection(peer:)
            redis { |r| r.hset(connections_key, peer, pack(authenticated: false)) }
          end

          def del_connection(peer:)
            redis { |r| r.hdel(connections_key, peer) }
          end

          def authenticate_client(peer:, name:, client:)
            redis do |r|
              hash = unpack(r.hget(connections_key, peer))
              hash.merge!("authenticated" => true, "name" => name, "client" => client)
              r.hset(connections_key, peer, pack(hash))
            end
          end

          def authenticated?(peer:)
            redis do |r|
              hash = unpack(r.hget(connections_key, peer))
              hash["authenticated"]
            end
          end

          def client_name(peer:)
            redis do |r|
              hash = unpack(r.hget(connections_key, peer))
              hash["name"].split("#").first
            end
          end

          def subscribe_client(peer:, handler:)
            Thread.new do
              unsubscribe_topic = "internal.punsub.#{peer}"
              redis do |r|
                r.psubscribe("#{BASE_PUBSUB_KEY}.*") do |on|
                  on.pmessage do |_glob, channel, message|
                    topic = channel.split(".")[1..-1].join(".")
                    next r.punsubscribe if topic == unsubscribe_topic
                    content = unpack(message)
                    handler.call(topic, content)
                  end
                end
              end
            end.tap do |t| # rubocop:disable Style/MultilineBlockChain
              t.name = "redis client subscription: #{peer}"
            end
          end

          def publish(topic:, content:)
            redis { |r| r.publish("#{BASE_PUBSUB_KEY}.#{topic}", pack(content)) }
          end

          def channel_create(channel_name:)
            redis do |r|
              return false if r.sismember("channels", channel_name)
              r.sadd("channels", channel_name)
            end
            true
          end

          def channel_list
            redis { |r| r.smembers("channels") }
          end

          def channel_join(user:, channel_name:)
            redis do |r|
              return false unless r.sismember("channels", channel_name)
              r.zadd("channel:#{channel_name}:users", 0, user)
            end
            true
          end

          def channel_part(user:, channel_name:)
            redis do |r|
              return false unless r.sismember("channels", channel_name)
              r.zrem("channel:#{channel_name}:users", user)
            end
            true
          end

          def channel_user_list(channel_name:)
            redis { |r| r.zrange("channel:#{channel_name}:users", 0, -1) }
          end

          private

          def redis(&block)
            Rrerrtriserv::Connection::Redis.instance.redis.with(&block)
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
