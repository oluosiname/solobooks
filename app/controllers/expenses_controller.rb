# frozen_string_literal: true

class ExpensesController < ApplicationController
  def new
    @expense = current_user.expenses.build
  end

  def create
    @expense = current_user.expenses.build(expense_params)

    if @expense.save
      respond_to do |format|
        format.html do
          redirect_to transactions_path, notice: t('record.create.success', resource: Expense.model_name.human)
        end
        format.turbo_stream { flash.now[:notice] = t('record.create.success', resource: Expense.model_name.human) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :date, :description)
  end
end
