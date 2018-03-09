# frozen_string_literal: true

require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendPart < Send
      def type
        "part"
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
