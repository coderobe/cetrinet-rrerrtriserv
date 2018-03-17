# frozen_string_literal: true

require "yaml"

require "rrerrtriserv/version"
require "rrerrtriserv/repository/redis_store"

module Rrerrtriserv
  module Web
    module Handler
      class Status
        REDIS_KEYS = %w[redis_version uptime_in_days connected_clients used_memory_human used_memory_peak_human].freeze

        def call(_request)
          [:ok, {}, build_response]
        end

        private

        def build_response
          {
            "version"  => "#{Rrerrtriserv::VERSION} (codename: #{Rrerrtriserv::CODENAME})",
            "redis"    => redis_status,
            "channels" => channel_list
          }.to_yaml
        end

        def redis_status
          Rrerrtriserv::Repository::RedisStore
            .redis_info
            .select { |k, _| REDIS_KEYS.include?(k) }
        end

        def channel_list
          Rrerrtriserv::Repository::RedisStore.channel_list.map do |channel|
            [
              channel,
              {
                "user_count" => Rrerrtriserv::Repository::RedisStore.channel_user_list(channel_name: channel).count
              }
            ]
          end.to_h
        end
      end
    end
  end
end
