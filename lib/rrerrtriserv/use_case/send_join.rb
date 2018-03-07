# frozen_string_literal: true

require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendJoin < Send
      def type
        "join"
      end

      def data
        {
          u: dto[:user],
          t: dto[:target]
        }
      end
    end
  end
end
