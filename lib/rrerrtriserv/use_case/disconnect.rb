# frozen_string_literal: true

require "socket"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/repository/web_socket_store"
require "rrerrtriserv/use_case/base"

module Rrerrtriserv
  module UseCase
    class Disconnect < Base
      def run
        Rrerrtriserv.logger.info "Client #{peer_to_s} disconnected"
        Rrerrtriserv::Repository::RedisStore.del_connection(peer: peer_to_s)
        # Note: This is a workaround because EventMachine is rubbish.
        Rrerrtriserv::Repository::WebSocketStore.delete(dto.fetch(:ws))
      end

      def peer_to_s
        # Note: This is a workaround because EventMachine is rubbish.
        @_peer_to_s ||= begin
                          ws_data = Rrerrtriserv::Repository::WebSocketStore[dto.fetch(:ws)]
                          return unless ws_data
                          ws_data[:peer]
                        end
      end
    end
  end
end
