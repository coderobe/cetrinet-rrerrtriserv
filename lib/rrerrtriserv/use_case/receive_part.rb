# frozen_string_literal: true

require "rrerrtriserv/errors"
require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/part_user"
require "rrerrtriserv/use_case/concerns/authentication"

module Rrerrtriserv
  module UseCase
    class ReceivePart < Base
      include Concerns::Authentication

      def run
        require_authentication!
        Rrerrtriserv.logger.info "received PART from #{client_name} to #{target}"
        raise Rrerrtriserv::Errors::NotInChannel.new if not_in_channel?
        part_channel
      end

      def data
        @_data ||= dto.fetch(:data)
      end

      def target
        data["t"]
      end

      private

      def not_in_channel?
        !Rrerrtriserv::Repository::RedisStore.channel_has_user?(
          channel_name: target,
          user:         client_name
        )
      end

      def part_channel
        Rrerrtriserv::UseCase::PartUser.new(
          ws:           ws,
          channel_name: target
        ).run
      end
    end
  end
end
