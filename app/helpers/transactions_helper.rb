# frozen_string_literal: true

module TransactionsHelper
  def format_transaction_amount(transaction)
    amount = number_to_currency(transaction.amount, unit: profile.invoice_currency.symbol)
    transaction.income? ? "+ #{amount}" : "- #{amount}"
  end

  def color_transaction_amount(transaction)
    transaction.income? ? 'text-green-600' : 'text-danger-700'
  end

  def transaction_receipt_icon(content_type)
    case content_type
    when 'image/jpeg', 'image/png'
      'fa-file-image'
    when 'application/pdf'
      'fa-file-pdf'
    else
      'fa-file'
    end
  end
end
