Gem::Specification.new do |spec|
  spec.name          = "verity-sdk"
  spec.version       = "1.0.0"
  spec.authors       = ["Verity API"]
  spec.email         = ["support@verity.backworkai.com"]

  spec.summary       = "Ruby SDK for the Verity API"
  spec.description   = "Ruby client library for the Verity API - Medicare coverage policies, prior authorization requirements, and medical code lookups"
  spec.homepage      = "https://github.com/Tylerbryy/verity-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Tylerbryy/verity-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/Tylerbryy/verity-ruby/blob/master/CHANGELOG.md"

  spec.files = Dir["lib/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "faraday-retry", "~> 2.0"
end
