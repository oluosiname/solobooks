# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    user
    date { Faker::Date.backward(days: 30) }
    due_date { Faker::Date.forward(days: 30) }
    total_amount { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    status { 'pending' }
    invoice_category
    vat_id { Faker::Lorem.word }
    tax_id { Faker::Lorem.word }
    vat { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    vat_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    vat_included { false }
    currency
    language { Faker::Lorem.word }
    subtotal { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    client

    transient do
      line_items_count { 3 }
    end

    after(:build) do |invoice, evaluator|
      invoice.line_items = build_list(:line_item, evaluator.line_items_count, invoice:)
    end
  end
end
