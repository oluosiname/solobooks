# frozen_string_literal: true

class ExpensesController < ApplicationController
  def create
    @transaction = current_user.expenses.build(expense_params)

    if @transaction.save
      respond_to do |format|
        format.html do
          redirect_to transactions_path, notice: t('record.create.success', resource: Expense.model_name.human)
        end
        format.turbo_stream { flash.now[:notice] = t('record.create.success', resource: Expense.model_name.human) }
      end
    else
      @categories = FinancialCategory.expense.order(:name)
      render 'transactions/new', status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :date, :description, :receipt, :financial_category_id)
  end
end
