# frozen_string_literal: true

require "confstruct"
require "yaml"

module Rrerrtriserv
  module Configuration
    DEFAULT_PATH = File.expand_path("../../config/rrerrtriserv.yml", __dir__)

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def config
        @config ||= reload_config(DEFAULT_PATH)
      end

      private

      def reload_config(path)
        @config = Confstruct::Configuration.new(YAML.load_file(path))
      end
    end
  end
end
