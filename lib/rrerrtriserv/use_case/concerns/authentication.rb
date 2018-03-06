# frozen_string_literal: true

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    module Concerns
      module Authentication
        def self.included(base)
          base.include(Concerns::WebSocket)
        end

        def require_authentication!
          return if Rrerrtriserv::Repository::RedisStore.authenticated?(peer: peer_to_s)
          Rrerrtriserv.logger.warn "#{peer_to_s} tried to send a message which requires authentication"
          raise "not authenticated"
        end
      end
    end
  end
end
