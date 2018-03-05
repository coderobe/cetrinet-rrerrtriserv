# frozen_string_literal: true

require "msgpack"

require "rrerrtriserv/use_case/base"

module Rrerrtriserv
  module UseCase
    class Send < Base
      def run
        dto[:ws].send(MessagePack.pack(payload), type: :binary)
      end

      def version
        1
      end

      def type
        raise NotImplementedError
      end

      def data
        nil
      end

      def payload
        {
          v: version,
          type: type,
          data: data
        }
      end
    end
  end
end
