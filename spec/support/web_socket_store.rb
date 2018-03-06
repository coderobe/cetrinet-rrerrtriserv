# frozen_string_literal: true

require "rrerrtriserv/repository/web_socket_store/strategy/in_memory"

RSpec.configure do |config|
  config.before(:each) do
    # clear inmemory web_socket store
    Rrerrtriserv::Repository::WebSocketStore::Strategy::InMemory.instance_variable_set("@store", {})
  end
end
