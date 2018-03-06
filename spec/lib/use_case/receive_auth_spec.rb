# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/receive_auth"

RSpec.describe Rrerrtriserv::UseCase::ReceiveAuth do
  let(:ws)     { EventMachineClient.new }
  let(:data)   { { "c" => client, "n" => name } }
  let(:client) { "cetrinet/0.1.0" }
  let(:name)   { "nilsding#Fnord31337" }

  let(:dto) { { ws: ws, data: data } }

  let(:use_case) { described_class.new(dto) }

  before do
    client_connect(ws)
  end

  describe "#run" do
    subject { use_case.run }

    context "client not yet authenticated" do
      it "authenticates the client" do
        with_redis do |redis|
          expect(MessagePack.unpack(redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)))
            .to include("authenticated" => false)
          subject
          expect(MessagePack.unpack(redis.hget("#{redis_test_ident}:connections", ws.__peer_to_s)))
            .to include("authenticated" => true)
        end
      end

      it "creates a redis subscription for the client" do
        allow(Rrerrtriserv::Repository::RedisStore)
          .to receive(:authenticate_client).with(peer: ws.__peer_to_s, name: name, client: client)
        subject
        expect(Rrerrtriserv::Repository::RedisStore).to have_received(:authenticate_client)
      end

      it "sends the MOTD to the client" do
        allow(Rrerrtriserv::UseCase::SendMotd).to receive(:new).with(ws: ws).and_call_original
        subject
        expect(Rrerrtriserv::UseCase::SendMotd).to have_received(:new)
      end
    end

    context "client already authenticated" do
      before do
        client_auth(ws, name: name, client: client)
      end

      it "fails" do
        expect { subject }.to raise_error("already authenticated")
      end
    end
  end
end
