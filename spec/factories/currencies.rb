# frozen_string_literal: true

FactoryBot.define do
  factory :currency do
    name { Faker::Currency.name }
    sequence :code do |n|
      "#{Faker::Currency.code}-#{n}"
    end

    symbol { Faker::Currency.symbol }
    active { true }
    default { false }

    trait :default do
      default { true }
      symbol { '€' }
      code { 'EUR' }
    end

    trait :inactive do
      active { false }
    end
  end
end
