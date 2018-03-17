# frozen_string_literal: true

require "rrerrtriserv/http_server"
require "rrerrtriserv/version"
require "rrerrtriserv/repository/redis_store"
require "rrerrtriserv/use_case/connect"
require "rrerrtriserv/use_case/disconnect"
require "rrerrtriserv/use_case/receive"
require "rrerrtriserv/use_case/send_error"

module Rrerrtriserv
  module Commands
    class Start
      def run
        Rrerrtriserv.logger.info "This is rrerrtriserv #{Rrerrtriserv::VERSION} - codename: #{Rrerrtriserv::CODENAME}"
        Rrerrtriserv.logger.info RUBY_DESCRIPTION

        check_redis!

        Rrerrtriserv::Repository::RedisStore.hewwo
        at_exit do
          Rrerrtriserv::Repository::RedisStore.perish
        end

        create_default_channel

        Rrerrtriserv::HTTPServer.start
      end

      private

      def check_redis!
        Rrerrtriserv::Repository::RedisStore.ping
      rescue StandardError => e
        abort(
          "\033[31;1mAn error occurred while trying to connect to Redis\033[0m\n"\
          "\033[1m#{e.class.name}\033[0m: #{e.message}"
        )
      end

      def create_default_channel
        Rrerrtriserv::Repository::RedisStore.channel_create(
          channel_name: Rrerrtriserv.config.default_channel
        )
      end
    end
  end
end
