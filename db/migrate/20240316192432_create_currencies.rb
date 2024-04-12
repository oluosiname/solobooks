# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :symbol, null: false
      t.boolean :active, default: false, null: false
      t.index [:code], name: 'index_currencies_on_code', unique: true
      t.index [:active], name: 'index_currencies_on_active'
      t.timestamps
    end
  end
end
