# frozen_string_literal: true

module Verity
  class Client
    DEFAULT_BASE_URL = 'https://verity.backworkai.com/api/v1'
    DEFAULT_TIMEOUT = 30

    attr_reader :api_key, :base_url, :timeout

    def initialize(api_key:, base_url: nil, timeout: nil)
      raise ArgumentError, 'api_key is required' if api_key.nil? || api_key.empty?

      @api_key = api_key
      @base_url = base_url || DEFAULT_BASE_URL
      @timeout = timeout || DEFAULT_TIMEOUT
    end

    def codes
      @codes ||= Resources::Codes.new(self)
    end

    def policies
      @policies ||= Resources::Policies.new(self)
    end

    def coverage
      @coverage ||= Resources::Coverage.new(self)
    end

    def prior_auth
      @prior_auth ||= Resources::PriorAuth.new(self)
    end

    def spending
      @spending ||= Resources::Spending.new(self)
    end

    def webhooks
      @webhooks ||= Resources::Webhooks.new(self)
    end

    def health
      request(:get, '/health')
    end

    # @private
    def request(method, path, params: nil, body: nil, headers: {})
      response = connection.send(method) do |req|
        req.url path
        req.params = params if params
        req.body = body.to_json if body
        req.headers = default_headers.merge(headers)
      end

      handle_response(response)
    rescue Faraday::Error => e
      raise APIError, "Request failed: #{e.message}"
    end

    private

    def connection
      @connection ||= Faraday.new(url: base_url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
        conn.options.timeout = timeout
        conn.options.open_timeout = 10
      end
    end

    def default_headers
      {
        'Authorization' => "Bearer #{api_key}",
        'Content-Type' => 'application/json',
        'User-Agent' => "verity-ruby/#{Verity::VERSION}"
      }
    end

    def handle_response(response)
      rate_limit_info = {
        limit: response.headers['x-ratelimit-limit']&.to_i,
        remaining: response.headers['x-ratelimit-remaining']&.to_i,
        reset: response.headers['x-ratelimit-reset']&.to_i
      }

      if response.status >= 400
        handle_error(response, rate_limit_info)
      end

      response.body
    end

    def handle_error(response, rate_limit_info)
      error_data = response.body.is_a?(Hash) ? response.body : {}
      error = error_data['error'] || {}
      message = error['message'] || "HTTP #{response.status}"
      code = error['code']
      details = error['details']

      case response.status
      when 401
        raise AuthError.new(message, code: code, details: details)
      when 404
        raise NotFoundError.new(message, code: code, details: details)
      when 400
        raise ValidationError.new(message, code: code, details: details)
      when 429
        raise RateLimitError.new(
          message,
          code: code,
          details: details,
          limit: rate_limit_info[:limit],
          remaining: rate_limit_info[:remaining],
          reset: rate_limit_info[:reset]
        )
      else
        raise APIError.new(message, code: code, details: details, status_code: response.status)
      end
    end
  end
end
