# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    @transactions = current_user.financial_transactions
  end
end
