# frozen_string_literal: true

require "msgpack"

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/send_motd"
require "rrerrtriserv/use_case/concerns/web_socket"

module Rrerrtriserv
  module UseCase
    class ReceiveAuth < Base
      include Concerns::WebSocket

      def run
        Rrerrtriserv.logger.info "received auth from #{peer_to_s}: #{name.split('#').first} (#{client})"
        Rrerrtriserv::Repository::RedisStore.authenticate_client(peer: peer_to_s, name: name, client: client)
        UseCase::SendMotd.new(ws: ws).run
      end

      def data
        @_data ||= dto.fetch(:data)
      end

      def client
        data["c"]
      end

      def name
        data["n"]
      end
    end
  end
end
