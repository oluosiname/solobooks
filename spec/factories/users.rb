# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
  end

  trait :confirmed do
    confirmed_at { Time.zone.now }
  end
end
