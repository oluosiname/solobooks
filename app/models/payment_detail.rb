# frozen_string_literal: true

class PaymentDetail < ApplicationRecord
  belongs_to :user

  validates :bank_name, :iban, :account_number, :account_holder, presence: true
end
