# frozen_string_literal: true

module Verity
  module Resources
    class Drugs
      def initialize(client)
        @client = client
      end

      def formulary(q, payer: 'all', limit: 25)
        @client.request(
          :get,
          '/drugs/formulary',
          params: { q: q, payer: payer, limit: limit }
        )
      end
    end
  end
end
