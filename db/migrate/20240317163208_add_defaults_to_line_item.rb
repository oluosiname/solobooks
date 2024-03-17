# frozen_string_literal: true

class AddDefaultsToLineItem < ActiveRecord::Migration[7.1]
  def change
    change_column_default :line_items, :quantity, from: nil, to: 1
    change_column_default :line_items, :unit_price, from: nil, to: 0
    change_column_default :line_items, :total_price, from: nil, to: 0
  end
end
