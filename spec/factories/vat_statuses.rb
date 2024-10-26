# frozen_string_literal: true

FactoryBot.define do
  factory :vat_status do
    user
    declaration_period { VatStatus.declaration_periods.keys.sample }
    vat_registered { true }
    starts_on { Faker::Date.between(from: '2024-01-01', to: '2024-12-31') }
    kleinunternehmer { false }
    tax_exempt_reason { vat_registered ? nil : Faker::Lorem.sentence }
    vat_number { Faker::Number.number(digits: 9) }

    trait :vat_exempt do
      vat_registered { false }
      tax_exempt_reason { 'VAT exemption according to §4 UStG' }
      kleinunternehmer { true }
    end

    trait :kleinunternehmer_exempt do
      vat_registered { false }
      kleinunternehmer { true }
      tax_exempt_reason { 'Small business exemption under §19 UStG' }
    end
  end
end
