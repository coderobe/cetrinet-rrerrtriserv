# frozen_string_literal: true

# Duck class which quacks like a normal EventMachine client connection
#
# NOTE: when using a different host or port, make sure to also unsubscribe
# from any redis connections
class EventMachineClient
  attr_reader :__last_sent

  def initialize(host: "127.1.0.1", port: "54321")
    @host = host
    @port = port
  end

  def send(message, type: :text) # rubocop:disable Lint/UnusedMethodArgument
    @__last_sent = message
  end

  def get_peername # rubocop:disable Naming/AccessorMethodName
    Socket.sockaddr_in(@port, @host)
  end

  def __peer_to_s
    "#{@host}:#{@port}"
  end
end
