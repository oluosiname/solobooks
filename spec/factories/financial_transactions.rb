# frozen_string_literal: true

FactoryBot.define do
  factory :financial_transaction do
    amount { Faker::Number.decimal(l_digits: 2) }
    description { Faker::Lorem.sentence }
    date { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
    category
  end
end
