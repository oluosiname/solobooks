class CreateBankConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_connections do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :institution_id
      t.string :requisition_id
      t.string :account_id, index: true
      t.string :connection_service
      t.string :status
      t.datetime :last_sync_at, index: true

      t.timestamps
    end

    add_index :bank_connections, :requisition_id, unique: true
  end
end
