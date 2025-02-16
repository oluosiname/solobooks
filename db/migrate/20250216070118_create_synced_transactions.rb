class CreateSyncedTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :synced_transactions do |t|
      t.string :creditor_name
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :booked_at, null: false
      t.string :transaction_id, null: false
      t.string :currency, null: false
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.timestamps
    end

    add_index :synced_transactions, :transaction_id, unique: true
  end
end
