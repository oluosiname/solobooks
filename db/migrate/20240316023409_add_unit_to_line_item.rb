# frozen_string_literal: true

class AddUnitToLineItem < ActiveRecord::Migration[7.1]
  def change
    add_column :line_items, :unit, :string
  end
end
