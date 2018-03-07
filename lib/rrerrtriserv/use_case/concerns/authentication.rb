# frozen_string_literal: true

require "rrerrtriserv/errors"
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
          raise Rrerrtriserv::Errors::Unauthorized.new
        end

        def not_authenticated!
          return unless Rrerrtriserv::Repository::RedisStore.authenticated?(peer: peer_to_s)
          Rrerrtriserv.logger.warn "#{peer_to_s} tried to send a message which prohibits authentication"
          raise Rrerrtriserv::Errors::AlreadyAuthenticated.new
        end

        def client_name
          @_client_name ||= Rrerrtriserv::Repository::RedisStore.client_name(peer: peer_to_s)
        end
      end
    end
  end
end
