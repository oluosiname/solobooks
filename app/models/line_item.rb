# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :invoice

  before_validation :calculate_total_price

  after_save :update_invoice_total_amount

  validates :description, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :total_price, presence: true
  validates :unit_price, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 255 }
  validates :quantity, numericality: { only_integer: true }

  UNITS = ['pc', 'hr'].freeze

  private

  def calculate_total_price
    self.total_price = quantity * unit_price
  end

  def update_invoice_total_amount
    invoice.update_total_amount
  end
end
