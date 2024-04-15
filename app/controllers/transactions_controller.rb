# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :build_transaction, only: [:new]

  def index
    @transactions = current_user.financial_transactions
  end

  def new; end

  def destroy
    @transaction = current_user.financial_transactions.find(params[:id])
    if @transaction.destroy
      redirect_to transactions_path, notice: t('record.destroy.success', resource: resource)
    else
      redirect_to transactions_path, alert: t('record.destroy.error', resource: resource)
    end
  end

  private

  def resource
    @transaction.transaction_type.constantize.model_name.human
  end

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
