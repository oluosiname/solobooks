# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    confirmed_at { Time.zone.now }
  end

  trait :confirmed do
    confirmed_at { Time.zone.now }
  end

  trait :unconfirmed do
    confirmed_at { nil }
  end

  trait :with_profile do
    after(:create) do |user|
      create(:profile, user:)
    end
  end

  trait :ready do
    after(:create) do |user|
      create(:profile, user:) if user.profile.blank?
      create(:payment_detail, user: user)
    end
  end
end
