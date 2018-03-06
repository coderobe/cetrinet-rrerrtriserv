# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/disconnect"

RSpec.describe Rrerrtriserv::UseCase::Disconnect do
  let(:ws) { EventMachineClient.new }

  let(:dto) { { ws: ws } }

  let(:use_case) { described_class.new(dto) }

  before do
    client_connect(ws)
  end

  describe "#run" do
    subject { use_case.run }

    it "removes a connection from the redis" do
      with_redis do |redis|
        expect(redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)).to be_msgpack
        subject
        expect(redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)).to be_nil
      end
    end

    it "removes the websocket from the websocket store" do
      expect(Rrerrtriserv::Repository::WebSocketStore[ws]).to be_a(Hash)
      subject
      expect(Rrerrtriserv::Repository::WebSocketStore[ws]).to be_nil
    end
  end
end
