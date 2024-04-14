# frozen_string_literal: true

class IncomesController < ApplicationController
  def create
    @transaction = current_user.incomes.build(income_params)

    if @transaction.save
      respond_to do |format|
        format.html do
          redirect_to transactions_path, notice: t('record.create.success', resource: Income.model_name.human)
        end
        format.turbo_stream { flash.now[:notice] = t('record.create.success', resource: Income.model_name.human) }
      end
    else
      render 'transactions/new', status: :unprocessable_entity
    end
  end

  private

  def income_params
    params.require(:income).permit(:amount, :date, :description)
  end
end
