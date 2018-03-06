# frozen_string_literal: true

module Rrerrtriserv
  module Pubsub
    module Handler
      class Base
        attr_reader :ws, :content, :topic

        def initialize(ws:, content:, topic:)
          @ws      = ws
          @content = content
          @topic   = topic
        end

        def run
          raise NotImplementedError
        end
      end
    end
  end
end
