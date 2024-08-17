class AddFinancialCategoryToFinancialTransaction < ActiveRecord::Migration[7.1]
  def change
    add_reference :financial_transactions, :financial_category, foreign_key: true
  end
end
