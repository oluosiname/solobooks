# frozen_string_literal: true

class ChangePrecisionForVat < ActiveRecord::Migration[7.1]
  def change
    change_column :invoices, :vat, :decimal, precision: 10, scale: 2
  end
end
