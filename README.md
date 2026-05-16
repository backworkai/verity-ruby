# Verity Ruby SDK

Official Ruby client for the [Verity API](https://verity.backworkai.com): Medicare coverage policies, medical code intelligence, prior authorization checks, claim validation, compliance review, and drug formulary evidence.

## Installation

Add the SDK to your Gemfile:

```ruby
gem 'verity-sdk'
```

Then install dependencies:

```bash
bundle install
```

Or install it directly:

```bash
gem install verity-sdk
```

Requires Ruby 2.7 or newer.

## Quick Start

```ruby
require 'verity'

client = Verity::Client.new(api_key: 'vrt_live_YOUR_API_KEY')

code = client.codes.lookup('76942', include: ['rvu', 'policies'])
puts code['data']['description']

prior_auth = client.prior_auth.check(
  procedure_codes: ['76942'],
  diagnosis_codes: ['M54.5'],
  state: 'TX',
  payer: 'medicare'
)

puts prior_auth['data']['pa_required']
```

Get an API key from the [Verity dashboard](https://verity.backworkai.com/dashboard).

## Core Workflows

### Code Lookup

```ruby
result = client.codes.lookup(
  '76942',
  include: ['rvu', 'policies'],
  jurisdiction: 'JM',
  fuzzy: true
)
```

### Policy Search and Retrieval

```ruby
policies = client.policies.list(
  q: 'ultrasound guidance',
  mode: 'keyword',
  policy_type: 'LCD',
  jurisdiction: 'JM',
  status: 'active',
  limit: 25
)

policy = client.policies.get('L33831', include: ['criteria', 'codes'])
```

### Prior Authorization and Claim Validation

```ruby
prior_auth = client.prior_auth.check(
  procedure_codes: ['76942'],
  diagnosis_codes: ['M54.5'],
  state: 'TX',
  payer: 'medicare'
)

claim = client.claims.validate(
  procedure_codes: ['99213'],
  diagnosis_codes: ['E11.9'],
  payer: 'Medicare',
  state: 'TX'
)

puts "#{claim['data']['coverage_status']} #{claim['data']['denial_risk']}"
```

### Coverage, Spending, and Compliance

```ruby
criteria = client.coverage.search_criteria(
  'diabetes',
  section: 'indications',
  limit: 10
)

spending = client.spending.by_code(codes: ['T1019', 'T1020'], year: 2023)
changes = client.compliance.unreviewed(limit: 10)
stats = client.compliance.stats
```

### Drug Formulary Evidence

```ruby
formulary = client.drugs.formulary('ozempic', payer: 'all', limit: 5)
```

## Error Handling

```ruby
begin
  result = client.codes.lookup('76942')
rescue Verity::AuthError => e
  puts "Invalid API key: #{e.message}"
rescue Verity::ValidationError => e
  puts "Invalid request: #{e.message}"
rescue Verity::NotFoundError => e
  puts "Resource not found: #{e.message}"
rescue Verity::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
rescue Verity::APIError => e
  puts "Verity API error: #{e.message}"
end
```

## Configuration

```ruby
client = Verity::Client.new(
  api_key: ENV.fetch('VERITY_API_KEY'),
  base_url: 'https://verity.backworkai.com/api/v1',
  timeout: 30
)
```

## Development

```bash
bundle install
ruby -c lib/verity.rb
```

## Support

- Documentation: https://verity.backworkai.com/docs
- Issues: https://github.com/backworkai/verity-ruby/issues
- Email: support@verity.backworkai.com

## License

MIT
