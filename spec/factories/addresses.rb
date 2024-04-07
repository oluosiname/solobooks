# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    addressable factory: [:client]
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    postal_code { Faker::Address.zip_code }
    country { Faker::Address.country }
  end
end
