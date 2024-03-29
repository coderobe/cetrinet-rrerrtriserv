# frozen_string_literal: true

require "rrerrtriserv/pubsub/handler/chat_message"
require "rrerrtriserv/pubsub/handler/join"
require "rrerrtriserv/pubsub/handler/part"

module Rrerrtriserv
  module Pubsub
    class Client
      TYPE_MAP = {
        "cmsg" => Pubsub::Handler::ChatMessage,
        "join" => Pubsub::Handler::Join,
        "part" => Pubsub::Handler::Part
      }.freeze

      attr_reader :ws

      def initialize(ws:)
        @ws = ws
      end

      def call(topic, content)
        Rrerrtriserv.logger.debug "#{self.class.name} call called with topic=>#{topic}, content=>#{content}"
        topic = topic.split(".")
        type = topic.first
        unless TYPE_MAP.key?(type)
          Rrerrtriserv.logger.warn "unknown type: #{type}, ignoring"
          return
        end
        TYPE_MAP[type].new(ws: ws, topic: topic, content: content).run
      end
    end
  end
end
