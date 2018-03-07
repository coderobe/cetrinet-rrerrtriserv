# frozen_string_literal: true

require "msgpack"

require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/receive_auth"
require "rrerrtriserv/use_case/receive_chat_message"
require "rrerrtriserv/use_case/receive_join"

module Rrerrtriserv
  module UseCase
    class Receive < Base
      TYPE_MAP = {
        "auth" => ReceiveAuth,
        "cmsg" => ReceiveChatMessage,
        "join" => ReceiveJoin
      }.freeze

      # dto args:
      # msg : String -- the msgpacked message
      # ws : WebSocket???
      def run
        unless TYPE_MAP.key?(type)
          Rrerrtriserv.logger.warn "unknown type: #{type}"
          return
        end
        TYPE_MAP[type].new(ws: dto[:ws], data: data).run
      end

      def unpacked_message
        @_unpacked_message ||= MessagePack.unpack(dto.fetch(:msg))
      end

      def type
        unpacked_message["t"]
      end

      def data
        unpacked_message["d"]
      end
    end
  end
end
