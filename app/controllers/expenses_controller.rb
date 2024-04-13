# frozen_string_literal: true

class ExpensesController < ApplicationController
  def new
    @expense = current_user.expenses.build
  end

  private

end
