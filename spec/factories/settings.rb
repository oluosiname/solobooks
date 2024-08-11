# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    profile
    language { Setting::LANGUAGES.keys.sample }
    currency_id { create(:currency).id }
  end
end
