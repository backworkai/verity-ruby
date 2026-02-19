# frozen_string_literal: true

module Verity
  module Resources
    class Policies
      def initialize(client)
        @client = client
      end

      def list(q: nil, mode: 'keyword', policy_type: nil, jurisdiction: nil, payer: nil, status: 'active', icd10: nil, format: nil, cursor: nil, limit: 50, include: nil)
        params = {}
        params[:q] = q if q
        params[:mode] = mode if mode
        params[:policy_type] = policy_type if policy_type
        params[:jurisdiction] = jurisdiction if jurisdiction
        params[:payer] = payer if payer
        params[:status] = status if status
        params[:icd10] = icd10 if icd10
        params[:format] = format if format
        params[:cursor] = cursor if cursor
        params[:limit] = limit if limit
        params[:include] = Array(include).join(',') if include

        @client.request(:get, '/policies', params: params)
      end

      def get(policy_id, include: nil)
        params = {}
        params[:include] = Array(include).join(',') if include

        @client.request(:get, "/policies/#{policy_id}", params: params)
      end

      def compare(procedure_codes:, policy_type: nil, jurisdictions: nil, idempotency_key: nil)
        body = { procedure_codes: procedure_codes }
        body[:policy_type] = policy_type if policy_type
        body[:jurisdictions] = jurisdictions if jurisdictions

        headers = {}
        headers['X-Idempotency-Key'] = idempotency_key if idempotency_key

        @client.request(:post, '/policies/compare', body: body, headers: headers)
      end

      def changes(since: nil, policy_id: nil, change_type: nil, cursor: nil, limit: 50)
        params = {}
        params[:since] = since if since
        params[:policy_id] = policy_id if policy_id
        params[:change_type] = change_type if change_type
        params[:cursor] = cursor if cursor
        params[:limit] = limit if limit

        @client.request(:get, '/policies/changes', params: params)
      end
    end
  end
end
