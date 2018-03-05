# frozen_string_literal: true

module Rrerrtriserv
  module UseCase
    class Base
      attr_reader :dto

      def initialize(dto)
        @dto = dto
      end

      def run
        raise NotImplementedError
      end
    end
  end
end
