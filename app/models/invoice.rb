# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :invoice_category
  belongs_to :user
  has_many :line_items, dependent: :destroy

  validates :date, presence: true
  validates :due_date, presence: true
  validates :total_amount, presence: true
  validates :status, presence: true
  validates_with InvoiceValidator::LineItemsValidator
  validates_with InvoiceValidator::DatesValidator
  # validates :invoice_number, presence: true

  before_validation :set_total_amount

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: :all_blank

  VAT_RATES = {
    '0%' => 0,
    '7%' => 7,
    '19%' => 19,
    '20%' => 20,
  }

  LANGUAGES = {
    'English' => 'en',
    'Deutsch' => 'de',
  }

  enum status: {
    pending: 'pending',
    sent: 'sent',
    paid: 'paid',
    cancelled: 'cancelled',
    refunded: 'refunded',
    due: 'due',
  }

  private

  def set_total_amount
    self.total_amount = line_items.sum(&:total_price)
  end
end
