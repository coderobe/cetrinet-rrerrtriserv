# frozen_string_literal: true

module Rrerrtriserv
  module Repository
    module WebSocketStore
      module Strategy
        class InMemory
          class << self
            def store
              @store ||= {}
            end
          end

          def [](ws)
            store[ws]
          end

          def []=(ws, data)
            store[ws] = data
          end

          def delete(ws)
            store.delete(ws)
          end

          private

          def store
            self.class.store
          end
        end
      end
    end
  end
end
