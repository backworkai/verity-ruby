# frozen_string_literal: true

module Verity
  module Resources
    class Codes
      def initialize(client)
        @client = client
      end

      def lookup(code, code_system: nil, jurisdiction: nil, include: nil, fuzzy: true)
        params = { code: code }
        params[:code_system] = code_system if code_system
        params[:jurisdiction] = jurisdiction if jurisdiction
        params[:include] = Array(include).join(',') if include
        params[:fuzzy] = fuzzy ? 'true' : 'false'

        @client.request(:get, '/codes/lookup', params: params)
      end
    end
  end
end
