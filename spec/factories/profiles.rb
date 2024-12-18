# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user
    legal_status { Profile.legal_statuses.keys.sample }
    full_name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    nationality { Faker::Nation.nationality }
    country { Faker::Address.country_code }
    business_name { Faker::Company.name }
    tax_number { Faker::Number.number(digits: 8) }
    vat_id { Faker::Number.number(digits: 9) }
    invoice_currency_id { create(:currency).id }
    invoice_language { 'en' }

    # Define nested attributes for Address
    after(:build) do |profile|
      profile.address ||= build(:address, addressable: profile)
    end

    trait :german do
      language { 'de' }
    end
  end
end
