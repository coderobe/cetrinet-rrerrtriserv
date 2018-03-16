# frozen_string_literal: true

require "spec_helper"

require "rrerrtriserv/use_case/receive"

RSpec.describe Rrerrtriserv::UseCase::Receive do
  let(:ws)      { ReelWebSocketClient.new }
  let(:msg)     { MessagePack.pack(payload) }
  let(:payload) { { v: 1, t: type, d: data } }
  let(:type)    { "???" }
  let(:data)    { {} }

  let(:dto) { { ws: ws, msg: msg } }

  let(:use_case) { described_class.new(dto) }

  describe "#run" do
    shared_examples_for "delegates to other use_case" do |the_type, use_case_class|
      context "when passing a message of type #{the_type.inspect}" do
        let(:type) { the_type }

        it "runs the #{use_case_class.name} use_case" do
          allow(use_case_class).to receive(:new).with(ws: ws, data: data).and_call_original
          allow_any_instance_of(use_case_class).to receive(:run)
          subject
          expect(use_case_class).to have_received(:new)
        end
      end
    end

    subject { use_case.run }

    include_examples "delegates to other use_case", "auth", Rrerrtriserv::UseCase::ReceiveAuth
    include_examples "delegates to other use_case", "cmsg", Rrerrtriserv::UseCase::ReceiveChatMessage

    context "when passing a message of unknown type" do
      it "does nothing" do
        subject
      end
    end
  end
end
