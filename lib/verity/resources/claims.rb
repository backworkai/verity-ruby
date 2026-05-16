# frozen_string_literal: true

module Verity
  module Resources
    class Claims
      def initialize(client)
        @client = client
      end

      def validate(procedure_codes:, payer: nil, plan_type: nil, line_of_business: nil, diagnosis_codes: nil, modifiers: nil, state: nil, site_of_service: nil, provider_specialty: nil, age_category: nil, sex_when_policy_relevant: nil, idempotency_key: nil)
        validate_at_path(
          '/claims/validate',
          procedure_codes: procedure_codes,
          payer: payer,
          plan_type: plan_type,
          line_of_business: line_of_business,
          diagnosis_codes: diagnosis_codes,
          modifiers: modifiers,
          state: state,
          site_of_service: site_of_service,
          provider_specialty: provider_specialty,
          age_category: age_category,
          sex_when_policy_relevant: sex_when_policy_relevant,
          idempotency_key: idempotency_key
        )
      end

      def validate_legacy(procedure_codes:, payer: nil, plan_type: nil, line_of_business: nil, diagnosis_codes: nil, modifiers: nil, state: nil, site_of_service: nil, provider_specialty: nil, age_category: nil, sex_when_policy_relevant: nil, idempotency_key: nil)
        validate_at_path(
          '/claim-validation',
          procedure_codes: procedure_codes,
          payer: payer,
          plan_type: plan_type,
          line_of_business: line_of_business,
          diagnosis_codes: diagnosis_codes,
          modifiers: modifiers,
          state: state,
          site_of_service: site_of_service,
          provider_specialty: provider_specialty,
          age_category: age_category,
          sex_when_policy_relevant: sex_when_policy_relevant,
          idempotency_key: idempotency_key
        )
      end

      private

      def validate_at_path(path, procedure_codes:, payer:, plan_type:, line_of_business:, diagnosis_codes:, modifiers:, state:, site_of_service:, provider_specialty:, age_category:, sex_when_policy_relevant:, idempotency_key:)
        body = { procedure_codes: procedure_codes }
        body[:payer] = payer if payer
        body[:plan_type] = plan_type if plan_type
        body[:line_of_business] = line_of_business if line_of_business
        body[:diagnosis_codes] = diagnosis_codes if diagnosis_codes
        body[:modifiers] = modifiers if modifiers
        body[:state] = state if state
        body[:site_of_service] = site_of_service if site_of_service
        body[:provider_specialty] = provider_specialty if provider_specialty
        body[:age_category] = age_category if age_category
        body[:sex_when_policy_relevant] = sex_when_policy_relevant if sex_when_policy_relevant

        headers = {}
        headers['X-Idempotency-Key'] = idempotency_key if idempotency_key

        @client.request(:post, path, body: body, headers: headers)
      end
    end
  end
end
