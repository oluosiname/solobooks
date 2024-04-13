# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    user
    amount { Faker::Number.decimal(l_digits: 2) }
    date { Faker::Date.between(from: 1.year.ago, to: Time.zone.today) }
    description { Faker::Lorem.sentence }
  end
end
