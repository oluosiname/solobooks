class AddDescriptionToSyncedTransaction < ActiveRecord::Migration[7.1]
  def change
    add_column :synced_transactions, :description, :string
  end
end
