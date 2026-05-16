# frozen_string_literal: true

module Verity
  module Resources
    class Compliance
      def initialize(client)
        @client = client
      end

      def unreviewed(change_type: nil, cursor: nil, limit: 50)
        params = { limit: limit }
        params[:change_type] = change_type if change_type
        params[:cursor] = cursor if cursor

        @client.request(:get, '/compliance/unreviewed', params: params)
      end

      def acknowledge(diff_id:, notes: nil)
        body = { diff_id: diff_id }
        body[:notes] = notes if notes

        @client.request(:post, '/compliance/ack', body: body)
      end

      def bulk_acknowledge(diff_ids:, notes: nil)
        body = { diff_ids: diff_ids }
        body[:notes] = notes if notes

        @client.request(:post, '/compliance/ack/bulk', body: body)
      end

      def stats
        @client.request(:get, '/compliance/stats')
      end
    end
  end
end
