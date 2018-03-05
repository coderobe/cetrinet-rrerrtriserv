# frozen_string_literal: true

require "logger"

module Rrerrtriserv
  module Logger
    def self.included(base)
      base.extend(ClassMethods)
      at_exit { Rrerrtriserv.logger.close }
    end

    module ClassMethods
      def logger
        @logger ||= ::Logger.new(STDOUT)
      end
    end
  end
end
