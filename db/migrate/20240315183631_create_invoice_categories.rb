# frozen_string_literal: true

class CreateInvoiceCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :invoice_categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
