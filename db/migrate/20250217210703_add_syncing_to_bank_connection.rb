class AddSyncingToBankConnection < ActiveRecord::Migration[7.1]
  def change
    add_column :bank_connections, :sync_enabled, :boolean, default: true
  end
end
