# frozen_string_literal: true

require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendChatMessage < Send
      def type
        "cmsg"
      end

      def data
        {
          m: dto[:message],
          t: dto[:target],
          s: dto[:source]
        }
      end
    end
  end
end
