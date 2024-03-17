# frozen_string_literal: true

class AddVatToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :vat, :decimal, precision: 5, scale: 2
    add_column :invoices, :vat_rate, :decimal, precision: 5, scale: 2
    add_column :invoices, :vat_included, :boolean, default: false
    # add_column :invoices, :vat_exemption, :boolean, default: false
    # add_column :invoices, :vat_exemption_reason, :string
    # add_column :invoices, :vat_exemption_document, :string
  end
end
