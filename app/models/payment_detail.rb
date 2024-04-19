# frozen_string_literal: true

class PaymentDetail < ApplicationRecord
  belongs_to :user

  validates  :account_number, :account_holder, presence: true
end
