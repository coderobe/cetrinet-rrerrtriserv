# frozen_string_literal: true

require "rrerrtriserv/pubsub/handler/base"
require "rrerrtriserv/use_case/send_chat_message"

module Rrerrtriserv
  module Pubsub
    module Handler
      class ChatMessage < Base
        def run
          Rrerrtriserv::UseCase::SendChatMessage.new(
            ws:      ws,
            message: content["message"],
            target:  topic[1],
            source:  content["source"]
          ).run
        end
      end
    end
  end
end
