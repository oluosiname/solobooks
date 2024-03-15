# frozen_string_literal: true

class AddColumnsToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :vat_id, :string
    add_column :invoices, :invoice_number, :string
    add_column :invoices, :tax_id, :string

    add_index :invoices, :invoice_number, unique: true
  end
end
