# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :invoice_category
  belongs_to :user
  has_many :line_items, dependent: :destroy

  validates :date, presence: true
  validates :due_date, presence: true
  validates :total_amount, presence: true
  validates :status, presence: true
  # validates :invoice_number, presence: true

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: :all_blank

  VAT_RATES = {
    '0%' => 0,
    '7%' => 7,
    '19%' => 19,
    '20%' => 20,
  }

  enum status: {
    pending: 'pending',
    sent: 'sent',
    paid: 'paid',
    cancelled: 'cancelled',
    refunded: 'refunded',
    due: 'due',
  }
end
