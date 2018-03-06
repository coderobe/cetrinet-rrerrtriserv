# frozen_string_literal: true

require "receptacle"

require "rrerrtriserv/repository/web_socket_store/strategy/in_memory"

module Rrerrtriserv
  module Repository
    module WebSocketStore
      include Receptacle::Repo

      strategy Rrerrtriserv::Repository::WebSocketStore::Strategy::InMemory

      mediate :[]
      mediate :[]=
      mediate :delete
    end
  end
end
