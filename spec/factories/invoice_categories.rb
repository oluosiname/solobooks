# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_category do
    sequence :name do |n|
      "#{Faker::Lorem.word}-#{n}"
    end
  end
end
