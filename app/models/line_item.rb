# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :invoice

  validates :description, presence: true
  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :total_price, presence: true
  validates :total_price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 255 }
  validates :quantity, numericality: { only_integer: true }

  UNITS = ['pc', 'hr'].freeze
end
