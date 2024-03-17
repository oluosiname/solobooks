# frozen_string_literal: true

class RemoveUnitFromLineItem < ActiveRecord::Migration[7.1]
  def change
    remove_column :line_items, :unit, :string
    change_column :line_items, :quantity, :integer, null: false
  end
end
