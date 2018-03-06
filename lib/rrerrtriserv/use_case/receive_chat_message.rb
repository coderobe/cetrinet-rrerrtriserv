# frozen_string_literal: true

require "msgpack"

require "rrerrtriserv/use_case/base"

module Rrerrtriserv
  module UseCase
    class ReceiveChatMessage < Base
      def run
        Rrerrtriserv.logger.info "received message from client to #{target}: #{message}"
        # TODO: distribute message to clients
      end

      def data
        @_data ||= dto.fetch(:data)
      end

      def target
        data["t"]
      end

      def message
        data["m"]
      end
    end
  end
end
