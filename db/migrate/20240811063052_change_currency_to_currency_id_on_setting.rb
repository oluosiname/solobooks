class ChangeCurrencyToCurrencyIdOnSetting < ActiveRecord::Migration[7.1]
  def change
    change_table :settings do |t|
      t.remove :currency
      t.belongs_to :currency, foreign_key: true
    end
  end
end
