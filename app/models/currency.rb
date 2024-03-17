# frozen_string_literal: true

class Currency < ApplicationRecord
  scope :active, -> { where(active: true) }

  validates :name, presence: true
  validates :code, presence: true
  validates :symbol, presence: true
  validates :active, inclusion: { in: [true, false] }

  def self.default_currency
    find_by(default: true)
  end

  def self.default_currency_code
    default_currency&.code
  end

  def self.default_currency_symbol
    default_currency&.symbol
  end
end
