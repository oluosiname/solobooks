# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    association :user
    legal_status { rand(2) } # Randomly assign legal status
    full_name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    nationality { Faker::Nation.nationality }
    country { Faker::Address.country }
    business_name { Faker::Company.name }
    tax_number { Faker::Number.number(digits: 8) }
    vat_id { Faker::Number.number(digits: 9) }
    currency_id { create(:currency).id }
    language { ['en', 'de'].sample }

    # Define nested attributes for Address
    after(:build) do |profile|
      profile.address ||= build(:address, addressable: profile)
    end
  end
end