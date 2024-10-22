# frozen_string_literal: true

FactoryBot.define do
  factory :vat_status do
    declaration_period { VatStatus.declaration_periods.keys.sample }
    vat_registered { true }
    starts_on { Faker::Date.between(from: '2024-01-01', to: '2024-12-31') }
    kleinstunternehmer { [true, false].sample }
    tax_exempt_reason { vat_registered ? nil : Faker::Lorem.sentence }
    vat_number { Faker::Number.number(digits: 9) }
  end
end
