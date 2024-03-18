# frozen_string_literal: true

class AddDefaultToVatRate < ActiveRecord::Migration[7.1]
  def change
    change_column_default :invoices, :vat_rate, from: nil, to: 0
  end
end
