# frozen_string_literal: true

require "rrerrtriserv/errors"
require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/base"
require "rrerrtriserv/use_case/join_user"
require "rrerrtriserv/use_case/concerns/authentication"

module Rrerrtriserv
  module UseCase
    class ReceiveJoin < Base
      include Concerns::Authentication

      def run
        require_authentication!
        Rrerrtriserv.logger.info "received JOIN from #{client_name} to #{target}"
        raise Rrerrtriserv::Errors::AlreadyInChannel.new if already_in_channel?
        create_channel
        join_channel
      end

      def data
        @_data ||= dto.fetch(:data)
      end

      def target
        data["t"]
      end

      private

      def already_in_channel?
        Rrerrtriserv::Repository::RedisStore.channel_has_user?(
          channel_name: target,
          user:         client_name
        )
      end

      def create_channel
        Rrerrtriserv::Repository::RedisStore.channel_create(
          channel_name: target
        )
      end

      def join_channel
        Rrerrtriserv::UseCase::JoinUser.new(
          ws:           ws,
          channel_name: target
        ).run
      end
    end
  end
end
