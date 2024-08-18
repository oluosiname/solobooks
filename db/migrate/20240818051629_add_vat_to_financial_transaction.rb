class AddVatToFinancialTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :financial_transactions, :vat_rate, :decimal, precision: 5, scale: 2, default: 0.0
  end
end
