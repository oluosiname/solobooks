class AddVatAmountToFinancialTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :financial_transactions, :vat_amount, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end
