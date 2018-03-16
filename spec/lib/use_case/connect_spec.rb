# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/connect"

RSpec.describe Rrerrtriserv::UseCase::Connect do
  let(:ws) { ReelWebSocketClient.new }

  let(:dto) { { ws: ws } }

  let(:use_case) { described_class.new(dto) }

  describe "#run" do
    subject { use_case.run }

    it "adds a connection state to the redis" do
      with_redis do |redis|
        expect(redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)).to be_nil
        subject
        expect(redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)).to be_msgpack
      end
    end

    it "marks the client as unauthenticated" do
      with_redis do |redis|
        subject
        value = redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)
        expect(value).to be_msgpack
        expect(MessagePack.unpack(value)).to include("authenticated" => false)
      end
    end
  end
end
