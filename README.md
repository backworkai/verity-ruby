# Verity Ruby SDK

Ruby client library for the [Verity API](https://verity.backworkai.com) - Medicare coverage policies, prior authorization requirements, and medical code lookups.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'verity-sdk'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install verity-sdk
```

## Quick Start

```ruby
require 'verity'

# Initialize the client
client = Verity::Client.new(api_key: 'vrt_live_YOUR_API_KEY')

# Look up a medical code
result = client.codes.lookup('76942')
puts result['data']['description']
# Output: "Ultrasonic guidance for needle placement"

# Check coverage policies
result = client.codes.lookup('76942', include: ['policies', 'rvu'])
result['data']['policies']&.each do |policy|
  puts "#{policy['policy_id']}: #{policy['title']}"
end
```

## Features

### Code Lookup

Look up CPT, HCPCS, ICD-10, and NDC codes:

```ruby
# Basic lookup
result = client.codes.lookup('76942')

# With options
result = client.codes.lookup(
  '76942',
  include: ['policies', 'rvu'],
  jurisdiction: 'JM',
  fuzzy: true
)

# Access the data
data = result['data']
puts "Code: #{data['code']}"
puts "System: #{data['code_system']}"
puts "Description: #{data['description']}"

# RVU information
if data['rvu']
  rvu = data['rvu']
  puts "Work RVU: #{rvu['work_rvu']}"
  puts "Facility Price: $#{rvu['facility_price']}"
end

# Associated policies
data['policies']&.each do |policy|
  puts "- #{policy['policy_id']}: #{policy['disposition']}"
end
```

### Policy Search

Search and retrieve coverage policies:

```ruby
# Search policies
result = client.policies.list(
  q: 'ultrasound guidance',
  mode: 'keyword',  # or 'semantic'
  policy_type: 'LCD',
  jurisdiction: 'JM',
  status: 'active',
  limit: 10
)

result['data'].each do |policy|
  puts "#{policy['policy_id']}: #{policy['title']}"
end

# Get detailed policy
policy = client.policies.get('L33831', include: ['criteria', 'codes', 'attachments'])

puts policy['data']['title']
puts policy['data']['description']

# Access criteria
if policy['data']['criteria']
  policy['data']['criteria'].each do |section, blocks|
    puts "\n#{section.upcase}:"
    blocks.each do |block|
      puts "  - #{block['text']}"
    end
  end
end
```

### Pagination

Handle paginated results:

```ruby
cursor = nil

loop do
  result = client.policies.list(q: 'diabetes', limit: 50, cursor: cursor)
  
  # Process current page
  result['data'].each do |policy|
    puts policy['title']
  end
  
  # Check for more pages
  pagination = result.dig('meta', 'pagination')
  break unless pagination&.dig('has_more')
  
  cursor = pagination['cursor']
end
```

### Policy Comparison

Compare policies across jurisdictions:

```ruby
result = client.policies.compare(
  procedure_codes: ['76942', '76937'],
  jurisdictions: ['JM', 'JH', 'JK'],
  policy_type: 'LCD'
)

# National policies
result.dig('data', 'national_policies')&.each do |policy|
  puts "National: #{policy['title']}"
end

# Jurisdiction-specific
result.dig('data', 'comparison')&.each do |comparison|
  jurisdiction = comparison['jurisdiction']
  mac = comparison.dig('mac', 'name')
  puts "\n#{jurisdiction} (#{mac}):"
  
  comparison['policies'].each do |policy|
    puts "  - #{policy['policy_id']}: #{policy['title']}"
  end
  
  summary = comparison['coverage_summary']
  puts "  Covered: #{summary['covered']}, Not Covered: #{summary['not_covered']}"
end
```

### Prior Authorization Check

Check if procedures require prior authorization:

```ruby
result = client.prior_auth.check(
  procedure_codes: ['76942', '76937'],
  diagnosis_codes: ['M54.5'],
  state: 'TX',
  payer: 'medicare'
)

data = result['data']
puts "PA Required: #{data['pa_required']}"
puts "Confidence: #{data['confidence']}"
puts "Reason: #{data['reason']}"

# Documentation requirements
if data['documentation_checklist']
  puts "\nDocumentation Required:"
  data['documentation_checklist'].each do |item|
    puts "  - #{item}"
  end
end

# Matched policies
data['matched_policies']&.each do |policy|
  puts "  - #{policy['policy_id']}: #{policy['title']}"
end
```

### Claim Validation

Validate coverage and denial risk before submission:

```ruby
result = client.claims.validate(
  procedure_codes: ['99213'],
  diagnosis_codes: ['E11.9'],
  payer: 'Medicare',
  state: 'TX'
)

data = result['data']
puts "Coverage: #{data['coverage_status']}"
puts "Denial risk: #{data['denial_risk']}"
```

### Coverage Criteria Search

Search through coverage criteria:

```ruby
result = client.coverage.search_criteria(
  'diabetes',
  section: 'indications',
  policy_type: 'LCD',
  jurisdiction: 'JM',
  limit: 25
)

result['data'].each do |criteria|
  puts "\nPolicy: #{criteria.dig('policy', 'title')}"
  puts "Section: #{criteria['section']}"
  puts "Text: #{criteria['text']}"
  puts "Tags: #{criteria['tags']&.join(', ')}"
end
```

### Jurisdictions

Get MAC jurisdiction information:

```ruby
result = client.coverage.jurisdictions

result['data'].each do |jurisdiction|
  puts "#{jurisdiction['jurisdiction_code']}: #{jurisdiction['mac_name']}"
  puts "  States: #{jurisdiction['states']&.join(', ')}"
  puts "  Website: #{jurisdiction['website_url']}"
end
```

### Compliance and Drug Formulary

Review policy changes and search pharmacy-benefit formulary evidence:

```ruby
changes = client.compliance.unreviewed(limit: 10)
stats = client.compliance.stats

formulary = client.drugs.formulary('ozempic', payer: 'all', limit: 5)

puts "Unreviewed changes: #{stats.dig('data', 'unreviewed_count')}"
formulary['data'].each do |item|
  puts "#{item['drug_name']}: #{item['coverage_status']}"
end
```

### Policy Changes

Track policy updates:

```ruby
result = client.policies.changes(
  since: '2024-01-01T00:00:00Z',
  change_type: 'codes_changed',
  limit: 50
)

result['data'].each do |change|
  puts "#{change['policy_id']}: #{change['change_type']}"
  puts "  Changed at: #{change['changed_at']}"
  if change.dig('details', 'change_summary')
    puts "  Details: #{change['details']['change_summary']}"
  end
end
```

## Error Handling

The SDK provides specific error types:

```ruby
begin
  result = client.codes.lookup('INVALID')
rescue Verity::ValidationError => e
  puts "Validation error: #{e.message}"
  puts "Error code: #{e.code}"
  puts "Details: #{e.details}"
rescue Verity::NotFoundError => e
  puts "Not found: #{e.message}"
rescue Verity::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
  puts "Limit: #{e.limit}"
  puts "Reset: #{e.reset}"
rescue Verity::AuthError => e
  puts "Authentication failed: #{e.message}"
rescue Verity::APIError => e
  puts "API error: #{e.message}"
  puts "Status code: #{e.status_code}"
end
```

## Configuration

### Custom Base URL

For testing or custom deployments:

```ruby
client = Verity::Client.new(
  api_key: 'vrt_test_YOUR_API_KEY',
  base_url: 'http://localhost:3000/api/v1'
)
```

### Timeout

Adjust request timeout (default: 30 seconds):

```ruby
client = Verity::Client.new(
  api_key: 'vrt_live_YOUR_API_KEY',
  timeout: 60  # 60 seconds
)
```

## Health Check

Check API status:

```ruby
health = client.health
puts "Status: #{health.dig('data', 'status')}"
puts "Database: #{health.dig('data', 'checks', 'database', 'status')}"
```

## Requirements

- Ruby 2.7 or higher
- Faraday ~> 2.0
- Faraday-retry ~> 2.0

## Support

- **Documentation**: [Verity API Docs](https://verity.backworkai.com/docs)
- **Issues**: [GitHub Issues](https://github.com/backworkai/verity-ruby/issues)
- **Email**: support@verity.backworkai.com

## License

MIT License - see LICENSE file for details.
