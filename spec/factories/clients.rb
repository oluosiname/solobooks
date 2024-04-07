# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    user
    name { Faker::Company.name }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    business_name { Faker::Company.name }
    business_tax_id { Faker::Company.ein }
    vat_number { Faker::Number.number(digits: 9) }

    after(:build) do |client|
      client.address = build(:address, addressable: client)
    end
  end
end
