# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/send_motd"

RSpec.describe Rrerrtriserv::UseCase::SendMotd do
  let(:ws)    { EventMachineClient.new }
  let(:error) { RuntimeError.new("oops, I did it again") }

  let(:dto) { { ws: ws, error: error } }

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
               "t" => "motd",
               "d" => {
                 "m" => Rrerrtriserv.config.motd
               })
    end
  end
end
