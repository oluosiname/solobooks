# frozen_string_literal: true

class CreateLineItems < ActiveRecord::Migration[7.1]
  def change
    create_table :line_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :description
      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2
      t.string :unit, null: false
      t.timestamps
    end
  end
end
