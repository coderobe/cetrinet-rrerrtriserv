# frozen_string_literal: true

require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/concerns/authentication"

module Rrerrtriserv
  module UseCase
    class ReceiveChatMessage < Base
      include Concerns::Authentication

      def run
        require_authentication!
        Rrerrtriserv.logger.info "received message from client to #{target}: #{message}"
        Rrerrtriserv::Repository::RedisStore.publish(
          topic: "cmsg.#{target}",
          content: { source: client_name, message: message }
        )
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
