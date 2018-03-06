# frozen_string_literal: true

require "msgpack"

require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/send_motd"

module Rrerrtriserv
  module UseCase
    class ReceiveAuth < Base
      def run
        Rrerrtriserv.logger.info "received auth for #{name.split('#').first} (#{client})"
        UseCase::SendMotd.new(ws: dto[:ws]).run
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
