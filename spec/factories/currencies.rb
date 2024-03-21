# frozen_string_literal: true

FactoryBot.define do
  factory :currency do
    name { Faker::Currency.name }
    code { Faker::Currency.code }
    symbol { Faker::Currency.symbol }
    active { true }
    default { false }

    trait :default do
      default { true }
    end

    trait :inactive do
      active { false }
    end
  end
end
