# frozen_string_literal: true

module Rrerrtriserv
  module Repository
    module RedisStore
      module Wrapper
        class Logger
          # FIXME: https://github.com/andreaseger/receptacle/issues/8
          # def before_hewwo()
          #   Rrerrtriserv.logger.debug "saying hewwo to redis"
          # end
          #
          # def before_perish()
          #   Rrerrtriserv.logger.debug "saying goodbye to redis"
          # end

          def before_add_connection(peer:)
            Rrerrtriserv.logger.debug "adding connection to redis: peer=>#{peer.inspect}"
            { peer: peer }
          end

          def before_del_connection(peer:)
            Rrerrtriserv.logger.debug "removing connection from redis: peer=>#{peer.inspect}"
            { peer: peer }
          end

          def before_authenticate_client(peer:, name:, client:)
            Rrerrtriserv.logger.debug "marking #{peer} as authenticated"
            { peer: peer, name: name, client: client }
          end

          def before_subscribe_client(peer:, handler:)
            Rrerrtriserv.logger.debug "creating new client subscription handler for #{peer}"
            { peer: peer, handler: handler }
          end

          def before_publish(topic:, content:)
            Rrerrtriserv.logger.debug "publishing #{topic} with content #{content.inspect}"
            { topic: topic, content: content }
          end
        end
      end
    end
  end
end
