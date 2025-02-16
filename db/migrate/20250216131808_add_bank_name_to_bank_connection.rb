class AddBankNameToBankConnection < ActiveRecord::Migration[7.1]
  def change
    add_column :bank_connections, :bank_name, :string
  end
end
