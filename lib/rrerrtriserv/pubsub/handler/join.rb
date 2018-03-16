# frozen_string_literal: true

require "rrerrtriserv/pubsub/handler/base"
require "rrerrtriserv/use_case/send_join"

module Rrerrtriserv
  module Pubsub
    module Handler
      class Join < Base
        def run
          Rrerrtriserv::UseCase::SendJoin.new(
            ws:      ws,
            target:  topic[1],
            user:    content["user"]
          ).run
        end
      end
    end
  end
end
