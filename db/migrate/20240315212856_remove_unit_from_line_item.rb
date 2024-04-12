# frozen_string_literal: true

class RemoveUnitFromLineItem < ActiveRecord::Migration[7.1]
  def up
    change_table :line_items, bulk: true do |t|
      t.remove :unit
      t.change :quantity, :integer, null: false
    end
  end

  def down
    change_table :line_items, bulk: true do |t|
      t.change :quantity, :integer, null: true
      t.column :unit, :string
    end
  end
end
