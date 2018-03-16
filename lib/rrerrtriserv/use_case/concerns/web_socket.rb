# frozen_string_literal: true

require "socket"

module Rrerrtriserv
  module UseCase
    module Concerns
      module WebSocket
        def ws
          @_ws ||= dto[:ws]
        end

        def peer
          @_peer ||= %i[port ip].zip(ws.peeraddr[1..2]).to_h
        end

        def peer_ip
          peer[:ip]
        end

        def peer_port
          peer[:port]
        end

        def peer_to_s
          [peer_ip, peer_port].join(":")
        end
      end
    end
  end
end
