# frozen_string_literal: true

require "rrerrtriserv/use_case/send"

module Rrerrtriserv
  module UseCase
    class SendMotd < Send
      def type
        "motd"
      end

      def data
        {
          m: Rrerrtriserv.config.motd
        }
      end
    end
  end
end
