# frozen_string_literal: true

# Duck class which quacks like a normal Reel web socket connection
#
# NOTE: when using a different host or port, make sure to also unsubscribe
# from any redis connections
class ReelWebSocketClient
  attr_reader :__last_sent

  def initialize(host: "127.1.0.1", port: "54321")
    @host = host
    @port = port
  end

  def write(message)
    @__last_sent = message.is_a?(Array) ? message.pack("C*") : message
  end

  def peeraddr
    ["AF_IDGAF", @port, @host, "127.2.2.66"]
  end

  def __peer_to_s
    "#{@host}:#{@port}"
  end
end
