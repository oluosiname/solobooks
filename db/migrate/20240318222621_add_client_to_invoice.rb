# frozen_string_literal: true

class AddClientToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :client, null: false, foreign_key: true
  end
end
