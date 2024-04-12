# frozen_string_literal: true

class AddDefaultToCurrency < ActiveRecord::Migration[7.1]
  def change
    add_column :currencies, :default, :boolean, default: false, null: false
  end
end
