# frozen_string_literal: true

require "msgpack"

RSpec::Matchers.define :be_msgpack do
  match do |payload|
    begin
      MessagePack.unpack(payload)
    rescue StandardError
      false
    end
  end
  description do
    "be a MessagePack-encoded message"
  end
  failure_message do |actual|
    "expected #{actual.inspect} to be a MessagePack-encoded message"
  end
end
