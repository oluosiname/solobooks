# frozen_string_literal: true

class AddDefaultsToLineItem < ActiveRecord::Migration[7.1]
  def change
    change_table :line_items, bulk: true do |t|
      t.change_default :quantity, from: nil, to: 1
      t.change_default :unit_price, from: nil, to: 0
      t.change_default :total_price, from: nil, to: 0
    end
  end
end
