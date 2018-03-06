# frozen_string_literal: true

require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendError < Send
      def type
        "error"
      end

      def data
        {
          m: error.message,
          c: error.class.name
        }
      end

      private

      def error
        @_error ||= dto.fetch(:error)
      end
    end
  end
end
