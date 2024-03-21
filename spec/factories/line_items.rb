# frozen_string_literal: true

FactoryBot.define do
  factory :line_item do
    invoice
    description { Faker::Lorem.sentence }
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    total_price { quantity * unit_price }
    unit { Faker::Lorem.word }
  end
end
