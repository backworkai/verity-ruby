# frozen_string_literal: true

module Verity
  module Resources
    class PriorAuth
      def initialize(client)
        @client = client
      end

      def check(procedure_codes:, diagnosis_codes: nil, state: nil, payer: 'medicare', criteria_page: 1, criteria_per_page: 25, idempotency_key: nil)
        body = { procedure_codes: procedure_codes }
        body[:diagnosis_codes] = diagnosis_codes if diagnosis_codes
        body[:state] = state if state
        body[:payer] = payer if payer
        body[:criteria_page] = criteria_page if criteria_page
        body[:criteria_per_page] = criteria_per_page if criteria_per_page

        headers = {}
        headers['X-Idempotency-Key'] = idempotency_key if idempotency_key

        @client.request(:post, '/prior-auth/check', body: body, headers: headers)
      end
    end
  end
end
