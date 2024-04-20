class AddVatSchemeToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :vat_technique, :string, default: :exempt, null: false
  end
end
