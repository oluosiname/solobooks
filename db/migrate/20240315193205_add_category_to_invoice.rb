# frozen_string_literal: true

class AddCategoryToInvoice < ActiveRecord::Migration[7.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference :invoices, :invoice_category, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn
  end
end
