# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_category do
    name { Faker::Lorem.word }
  end
end
