# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :build_transaction, only: [:new]
  before_action :set_categories, only: [:new]

  def index
    @grouped_transactions = current_user.financial_transactions
      .order(date: :desc)
      .group_by { |transaction| transaction.date.strftime('%B %Y') }
  end

  def new; end

  def edit
    @transaction = current_user.financial_transactions.find_by(id: params[:id])
    @categories = FinancialCategory.send(@transaction.transaction_type.downcase).order(:name)
  end

  def update
    @transaction = current_user.financial_transactions.find_by(id: params[:id])

    if @transaction.update(transaction_params)
      respond_to do |format|
        format.html do
          redirect_to transactions_path, notice: t('record.update.success', resource: @transaction.model_name.human)
        end
        format.turbo_stream do
          # TODO: Decide if we are replacing the whole list or just adding the new record
          # @transactions = current_user.financial_transactions.order(date: :desc)
          flash.now[:notice] = t('record.update.success', resource: @transaction.model_name.human)
        end
      end
    else
      @categories = FinancialCategory.income.order(:name)
      render 'transactions/edit', status: :unprocessable_entity
    end
  end

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

  def transaction_params
    params.require(@transaction.transaction_type.downcase.to_sym).permit(
      :amount,
      :date,
      :description,
      :receipt,
      :financial_category_id,
      :vat_rate
    )
  end

  def set_categories
    transaction_type = params[:transaction_type] == 'income' ? 'income' : 'expense'
    @categories = FinancialCategory.send(transaction_type).order(:name)
  end
end
