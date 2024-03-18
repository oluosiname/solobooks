# frozen_string_literal: true

class AddSubtotalToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :subtotal, :decimal, precision: 10, scale: 2
  end
end
