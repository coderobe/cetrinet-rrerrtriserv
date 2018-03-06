# frozen_string_literal: true

require "rrerrtriserv/use_case/connect"
require "rrerrtriserv/use_case/receive_auth"

def client_connect(ws)
  Rrerrtriserv::UseCase::Connect.new(ws: ws).run
end

def client_auth(ws, name: "nilsding#Fnord31337", client: "cetrinet/0.1.0")
  Rrerrtriserv::UseCase::ReceiveAuth.new(ws: ws, data: { "c" => client, "n" => name }).run
end
