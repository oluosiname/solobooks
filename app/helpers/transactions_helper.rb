# frozen_string_literal: true

module TransactionsHelper
  def format_transaction_amount(transaction)
    amount = number_to_currency(transaction.amount, unit: current_user.profile.currency.symbol)
    transaction.income? ? "+ #{amount}" : "- #{amount}"
  end

  def color_transaction_amount(transaction)
    transaction.income? ? 'text-green-600' : 'text-danger-700'
  end
end
