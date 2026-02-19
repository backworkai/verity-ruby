# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'json'

require_relative 'verity/version'
require_relative 'verity/errors'
require_relative 'verity/client'
require_relative 'verity/resources/codes'
require_relative 'verity/resources/policies'
require_relative 'verity/resources/coverage'
require_relative 'verity/resources/prior_auth'
require_relative 'verity/resources/spending'
require_relative 'verity/resources/webhooks'

module Verity
  class Error < StandardError; end
end
