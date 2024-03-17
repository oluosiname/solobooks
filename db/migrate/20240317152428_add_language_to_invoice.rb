# frozen_string_literal: true

class AddLanguageToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :language, :string
  end
end
