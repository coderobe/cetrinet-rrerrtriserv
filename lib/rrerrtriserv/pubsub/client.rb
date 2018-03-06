# frozen_string_literal: true

module Rrerrtriserv
  module Pubsub
    class Client
      attr_reader :ws

      def initialize(ws:)
        @ws = ws
      end

      def call(topic, content)
        Rrerrtriserv.logger.debug "#{self.class.name} call called with topic=>#{topic}, content=>#{content}"
      end
    end
  end
end
