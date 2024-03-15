# frozen_string_literal: true

class AddCategoryToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :invoice_category, null: false, foreign_key: true
  end
end
