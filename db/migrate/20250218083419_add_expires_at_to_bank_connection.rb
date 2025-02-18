class AddExpiresAtToBankConnection < ActiveRecord::Migration[7.1]
  def change
    add_column :bank_connections, :expires_at, :datetime, null: false
    add_index :bank_connections, :expires_at
  end
end
