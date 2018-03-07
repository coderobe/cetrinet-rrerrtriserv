# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/receive_chat_message"

RSpec.describe Rrerrtriserv::UseCase::ReceiveChatMessage do
  let(:ws)      { EventMachineClient.new }
  let(:data)    { { "t" => target, "m" => message } }
  let(:target)  { "#lobby" }
  let(:message) { "owo what's this?" }

  let(:dto) { { ws: ws, data: data } }

  let(:use_case) { described_class.new(dto) }

  before do
    client_connect(ws)
  end

  describe "#run" do
    subject { use_case.run }

    context "client not yet authenticated" do
      it "fails" do
        expect { subject }.to raise_error(Rrerrtriserv::Errors::Unauthorized)
      end
    end

    context "client authenticated" do
      before do
        client_auth(ws, name: "ramses#fjordor59512")
      end

      it "publishes the message to redis" do
        allow(Rrerrtriserv::Repository::RedisStore)
          .to receive(:publish).with(topic: "cmsg.#{target}", content: { source: "ramses", message: message })
        subject
        expect(Rrerrtriserv::Repository::RedisStore).to have_received(:publish)
      end
    end
  end
end
