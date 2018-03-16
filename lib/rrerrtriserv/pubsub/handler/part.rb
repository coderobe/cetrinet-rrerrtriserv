# frozen_string_literal: true

require "rrerrtriserv/pubsub/handler/base"
require "rrerrtriserv/use_case/send_part"

module Rrerrtriserv
  module Pubsub
    module Handler
      class Part < Base
        def run
          Rrerrtriserv::UseCase::SendPart.new(
            ws:      ws,
            target:  topic[1],
            user:    content["user"]
          ).run
        end
      end
    end
  end
end
