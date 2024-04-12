class AddUniquenessIndexToClient < ActiveRecord::Migration[7.1]
  def change
    change_table :clients, bulk: true do |t|
      t.index [:email, :user_id], unique: true
    end
  end
end
