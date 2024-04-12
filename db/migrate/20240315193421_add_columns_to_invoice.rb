# frozen_string_literal: true

class AddColumnsToInvoice < ActiveRecord::Migration[7.1]
  def change
    change_table :invoices, bulk: true do |t|
      t.column :vat_id, :string
      t.column :invoice_number, :string
      t.column :tax_id, :string

      t.index :invoice_number, unique: true
    end
  end
end
