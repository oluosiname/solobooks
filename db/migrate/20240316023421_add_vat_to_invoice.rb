# frozen_string_literal: true

class AddVatToInvoice < ActiveRecord::Migration[7.1]
  def change
    change_table :invoices, bulk: true do |t|
      t.column :vat, :decimal, precision: 5, scale: 2
      t.column :vat_rate, :decimal, precision: 5, scale: 2
      t.column :vat_included, :boolean, default: false, null: false
    end
    # add_column :invoices, :vat_exemption, :boolean, default: false
    # add_column :invoices, :vat_exemption_reason, :string
    # add_column :invoices, :vat_exemption_document, :string
  end
end
