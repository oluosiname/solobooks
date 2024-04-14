# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :build_transaction, only: [:new]

  def index
    @transactions = current_user.financial_transactions
  end

  def new; end

  private

  def build_transaction
    @transaction = params[:transaction_type] == 'income' ? build_income : build_expense
  end

  def build_expense
    current_user.expenses.build
  end

  def build_income
    current_user.incomes.build
  end
end
