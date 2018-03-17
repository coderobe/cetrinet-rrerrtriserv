# frozen_string_literal: true

require "rrerrtriserv/version"

module Rrerrtriserv
  module Web
    class Router
      ERROR_MESSAGE = "<h1>OOPSIE WOOPSIE!!</h1>\n" \
                      "<p>Uwu We made a fucky wucky!! A wittle fucko boingo!\n" \
                      "<p>The code monkeys at our headquarters are working VEWY HAWD to fix this\n"

      DEFAULT_HEADERS = {
        "Server" => "rrerrtriserv/#{Rrerrtriserv::VERSION} (codename: #{Rrerrtriserv::CODENAME})"
      }.freeze

      NOT_FOUND = [:not_found, {}, "<h1>Not found</h1>\n"].freeze
      INTERNAL_SERVER_ERROR = [:internal_server_error, {}, ERROR_MESSAGE].freeze

      def initialize
        @routes = {}
      end

      def process(request) # rubocop:disable Metrics/AbcSize
        status, headers, body = NOT_FOUND
        begin_time = Time.now
        path = real_path(request)
        handler = @routes[path]

        return unless handler

        status, headers, body = safe_response { handler.call(request) }
      rescue StandardError => e
        Rrerrtriserv.logger.error "got a #{e.class} while processing request -- #{e.message}\n" \
                                  "> #{e.backtrace.join("\n> ")}"

        status, headers, body = INTERNAL_SERVER_ERROR
      ensure
        time_diff = Time.now - begin_time
        Rrerrtriserv.logger.info format("#{request.method} #{path} -> #{status.inspect} [%.5fs]", time_diff)
        request.respond(status, DEFAULT_HEADERS.merge(headers), body)
      end

      def register_route(path, action)
        path = "/#{path}" unless path.start_with?("/")
        @routes[path] = action
      end

      def finalize_routes!
        @routes.freeze
      end

      private

      def real_path(request)
        return "/" if request.path.empty?
        request.path
      end

      def safe_response # rubocop:disable Metrics/AbcSize
        yield.tap do |x|
          next if x.is_a?(Array) && x.count == 3 &&
                      (x[0].is_a?(Symbol) || x[0].is_a?(Integer)) &&
                      x[1].is_a?(Hash) &&
                      x[2].is_a?(String)
          raise ArgumentError.new("invalid response from our code! w00t")
        end
      end
    end
  end
end
