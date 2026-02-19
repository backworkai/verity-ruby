# frozen_string_literal: true

module Verity
  module Resources
    class Coverage
      def initialize(client)
        @client = client
      end

      def search_criteria(q, section: nil, policy_type: nil, jurisdiction: nil, cursor: nil, limit: 50)
        params = { q: q }
        params[:section] = section if section
        params[:policy_type] = policy_type if policy_type
        params[:jurisdiction] = jurisdiction if jurisdiction
        params[:cursor] = cursor if cursor
        params[:limit] = limit if limit

        @client.request(:get, '/coverage/criteria', params: params)
      end

      def jurisdictions
        @client.request(:get, '/jurisdictions')
      end

      def evaluate(policy_id:, parameters:)
        @client.request(:post, '/coverage/evaluate', body: { policy_id: policy_id, parameters: parameters })
      end
    end
  end
end
