class CreateFinancialTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_transactions do |t|
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :date, null: false
      t.string :transaction_type, null: false, index: true
      t.string :description
      t.timestamps
    end
  end
end
