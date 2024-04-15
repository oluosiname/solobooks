# frozen_string_literal: true

FactoryBot.define do
  factory :payment_detail do
    user
    bank_name { Faker::Bank.name }
    iban { Faker::Bank.iban }
    swift { Faker::Bank.swift_bic }
    account_number { Faker::Bank.account_number(digits: 10) }
    sort_code { Faker::Bank.uk_account_number }
    routing_number { Faker::Bank.routing_number }
    account_holder { Faker::Name.name }
  end
end
