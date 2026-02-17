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

      def research(procedure_codes:, payer: nil, state: nil, diagnosis_codes: nil, clinical_context: nil, sync: false)
        body = { procedure_codes: procedure_codes, sync: sync }
        body[:payer] = payer if payer
        body[:state] = state if state
        body[:diagnosis_codes] = diagnosis_codes if diagnosis_codes
        body[:clinical_context] = clinical_context if clinical_context

        @client.request(:post, '/prior-auth/research', body: body)
      end

      def get_research(research_id)
        @client.request(:get, "/prior-auth/research/#{research_id}")
      end
    end
  end
end
