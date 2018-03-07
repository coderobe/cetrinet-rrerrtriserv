# frozen_string_literal: true

module Rrerrtriserv
  module Utils
    module_function

    def underscore(word)
      word.scan(/[A-Z][^A-Z]+/).map(&:downcase).join("_")
    end
  end
end
