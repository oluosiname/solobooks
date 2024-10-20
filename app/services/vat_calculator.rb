# frozen_string_literal: true

class VatCalculator < ApplicationService
  def initialize(user:, start_date:, end_date:)
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def call
    {
      total_sales_vat: sum_vat_amount(user.incomes),
      total_expense_vat: sum_vat_amount(user.expenses),
      net_vat_payable: net_vat,
    }
  end

  private

  attr_reader :user, :start_date, :end_date

  def sum_vat_amount(transactions)
    transactions.where(date: start_date..end_date).sum(:vat_amount)
  end

  def net_vat
    sum_vat_amount(user.incomes) - sum_vat_amount(user.expenses)
  end
end
