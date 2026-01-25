# frozen_string_literal: true

module Verity
  class APIError < StandardError
    attr_reader :code, :details, :status_code

    def initialize(message, code: nil, details: nil, status_code: nil)
      super(message)
      @code = code
      @details = details
      @status_code = status_code
    end
  end

  class AuthError < APIError
    def initialize(message, code: nil, details: nil)
      super(message, code: code, details: details, status_code: 401)
    end
  end

  class NotFoundError < APIError
    def initialize(message, code: nil, details: nil)
      super(message, code: code, details: details, status_code: 404)
    end
  end

  class ValidationError < APIError
    def initialize(message, code: nil, details: nil)
      super(message, code: code, details: details, status_code: 400)
    end
  end

  class RateLimitError < APIError
    attr_reader :limit, :remaining, :reset

    def initialize(message, code: nil, details: nil, limit: nil, remaining: nil, reset: nil)
      super(message, code: code, details: details, status_code: 429)
      @limit = limit
      @remaining = remaining
      @reset = reset
    end
  end
end
