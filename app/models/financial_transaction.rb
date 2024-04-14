# frozen_string_literal: true

class FinancialTransaction < ApplicationRecord
  self.inheritance_column = :transaction_type
  belongs_to :user

  validates :amount, presence: true
  validates :date, presence: true
  validates :transaction_type, presence: true

  def income?
    transaction_type == 'Income'
  end

  def expense?
    transaction_type == 'Expense'
  end
end
