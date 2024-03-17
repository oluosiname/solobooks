# frozen_string_literal: true

class AddCurrencyToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :currency, foreign_key: true
  end
end
