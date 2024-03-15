# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :invoice_category
  has_many :line_items, dependent: :destroy

  validates :date, presence: true
  validates :due_date, presence: true
  validates :total_amount, presence: true
  validates :status, presence: true
  validates :client, presence: true
  validates :invoice_number, presence: true

  enum status: {
    pending: 'pending',
    sent: 'sent',
    paid: 'paid',
    cancelled: 'cancelled',
    refunded: 'refunded',
    due: 'due',
  }
end
