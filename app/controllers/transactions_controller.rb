# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :build_transaction, only: [:new]

  def index
    @transactions = current_user.financial_transactions
  end

  def new; end

  private

  def build_transaction
    @transaction = send("build_#{params[:transaction_type]}")
  end

  def build_expense
    current_user.expenses.build
  end

  def build_income
    current_user.incomes.build
  end
end
