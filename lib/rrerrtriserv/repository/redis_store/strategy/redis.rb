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
              redis do |r|
                r.psubscribe("#{BASE_PUBSUB_KEY}.*") do |on|
                  on.pmessage do |_glob, channel, message|
                    topic = channel.split(".")[1..-1].join(".")
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
