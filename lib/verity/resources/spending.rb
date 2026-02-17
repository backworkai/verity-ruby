# frozen_string_literal: true

module Verity
  module Resources
    class Spending
      def initialize(client)
        @client = client
      end

      def by_code(code: nil, codes: nil, year: nil)
        params = {}
        params[:code] = code if code
        params[:codes] = codes.join(',') if codes
        params[:year] = year if year

        @client.request(:get, '/spending/by-code', params: params)
      end
    end
  end
end
