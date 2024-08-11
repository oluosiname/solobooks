# frozen_string_literal: true

class IncomesController < ApplicationController
  def create
    @transaction = current_user.incomes.build(income_params)

    if @transaction.save
      respond_to do |format|
        format.html do
          redirect_to transactions_path, notice: t('record.create.success', resource: Income.model_name.human)
        end
        format.turbo_stream do
          # TODO: Decide if we are replacing the whole list or just adding the new record
          # @transactions = current_user.financial_transactions.order(date: :desc)
          flash.now[:notice] = t('record.create.success', resource: Income.model_name.human)
        end
      end
    else
      render 'transactions/new', status: :unprocessable_entity
    end
  end

  private

  def income_params
    params.require(:income).permit(:amount, :date, :description, :receipt)
  end
end
