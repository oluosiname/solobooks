class AddAccountNumberToBankConnection < ActiveRecord::Migration[7.1]
  def change
    add_column :bank_connections, :account_number, :string
  end
end
