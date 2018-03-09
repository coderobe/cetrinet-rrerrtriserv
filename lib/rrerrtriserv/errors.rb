# frozen_string_literal: true

require "rrerrtriserv/utils"

module Rrerrtriserv
  module Errors
    class Base < StandardError
      def code
        @code ||= Utils.underscore(self.class.name.split("::", 3).last)
      end
    end

    class Unauthorized < Base
      def initialize(message = "Not authorized to perform this action")
        super
      end
    end

    class AlreadyAuthenticated < Base
      def initialize(message = "You are already authenticated")
        super
      end
    end

    class AlreadyInChannel < Base
      def initialize(message = "You are already in this channel")
        super
      end
    end

    class NotInChannel < Base
      def initialize(message = "You are not part of this channel")
      end
    end
  end
end
