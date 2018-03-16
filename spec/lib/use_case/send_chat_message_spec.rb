# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/send_chat_message"

RSpec.describe Rrerrtriserv::UseCase::SendChatMessage do
  let(:ws)      { ReelWebSocketClient.new }
  let(:source)  { "ramses" }
  let(:target)  { "#lobby" }
  let(:message) { "owo what's this?" }

  let(:dto) { { ws: ws, message: message, target: target, source: source } }

  let(:use_case) { described_class.new(dto) }

  before do
    client_connect(ws)
  end

  describe "#run" do
    subject { use_case.run }

    it "sends a msgpack encoded message" do
      subject
      expect(ws.__last_sent).to be_msgpack
    end

    it "sent message has the expected payload" do
      subject
      expect(MessagePack.unpack(ws.__last_sent))
        .to eq("v" => 1,
               "t" => "cmsg",
               "d" => {
                 "t" => target,
                 "m" => message,
                 "s" => source
               })
    end
  end
end
