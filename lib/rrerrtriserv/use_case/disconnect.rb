# frozen_string_literal: true

require "socket"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    class Disconnect < Base
      include Concerns::WebSocket

      def run
        Rrerrtriserv.logger.info "Client #{peer_to_s} disconnected"
        Rrerrtriserv::Repository::RedisStore.del_connection(peer: peer_to_s)
      end
    end
  end
end
