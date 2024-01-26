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
          @_peer ||= {:ip => "127.0.0.1", :port => "28420"}
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
