# frozen_string_literal: true

module Verity
  module Resources
    class Webhooks
      def initialize(client)
        @client = client
      end

      def list
        @client.request(:get, '/webhooks')
      end

      def create(url:, events:)
        @client.request(:post, '/webhooks', body: { url: url, events: events })
      end

      def update(webhook_id, url: nil, events: nil, status: nil)
        body = {}
        body[:url] = url if url
        body[:events] = events if events
        body[:status] = status if status
        @client.request(:patch, "/webhooks/#{webhook_id}", body: body)
      end

      def delete(webhook_id)
        @client.request(:delete, "/webhooks/#{webhook_id}")
      end

      def test(webhook_id)
        @client.request(:post, "/webhooks/#{webhook_id}/test")
      end
    end
  end
end
