class ChangeLegalStatusToString < ActiveRecord::Migration[7.1]
  def change
    change_column :profiles, :legal_status, :string
  end
end
