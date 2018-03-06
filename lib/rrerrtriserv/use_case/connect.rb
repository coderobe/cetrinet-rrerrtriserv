# frozen_string_literal: true

require "socket"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/repository/web_socket_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    class Connect < Base
      include Concerns::WebSocket

      def run
        Rrerrtriserv.logger.info "Client #{peer_to_s} connected, waiting for auth..."
        Rrerrtriserv::Repository::RedisStore.add_connection(peer: peer_to_s)
        # Note: This is a workaround because EventMachine is rubbish.
        Rrerrtriserv::Repository::WebSocketStore[ws] = { peer: peer_to_s }
      end
    end
  end
end
