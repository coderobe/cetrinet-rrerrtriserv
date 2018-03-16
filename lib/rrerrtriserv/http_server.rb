# frozen_string_literal: true

require "celluloid/current"
require "reel"

module Rrerrtriserv
  class HTTPServer < Reel::Server::HTTP
    def initialize
      super(
        Rrerrtriserv.config.server.host,
        Rrerrtriserv.config.server.port,
        &method(:on_connection)
      )
    end

    def self.start
      Rrerrtriserv.logger.info "Starting Reel server"
      run
    end

    private

    def on_connection(connection)
      while (request = connection.request)
        if request.websocket?
          connection.detach

          handle_websocket(request.websocket)
          return
        else
          handle_request(request)
        end
      end
    end

    def handle_websocket(ws)
      Rrerrtriserv::UseCase::Connect.new(ws: ws).run
      while !ws.socket.eof? && (msg = ws.read)
        next unless msg.is_a?(Array)
        receive(ws, msg.pack("C*"))
      end
      Rrerrtriserv::UseCase::Disconnect.new(ws: ws).run
    rescue StandardError => e
      Rrerrtriserv.logger.error(e)
    end

    def receive(ws, msg)
      Rrerrtriserv.logger.debug "Received message: #{msg.inspect}"
      Rrerrtriserv::UseCase::Receive.new(ws: ws, msg: msg).run
    rescue StandardError => e
      Rrerrtriserv::UseCase::SendError.new(ws: ws, error: e).run
    end

    def handle_request(request)
      Rrerrtriserv.logger.warn "normal http request! wtf!"
      request.respond :ok, "cool\n"
    end
  end
end
