# frozen_string_literal: true

FactoryBot.define do
  factory :financial_category do
    name { Faker::Lorem.word }
    category_type { FinancialCategory.category_types.keys.sample }
  end
end
