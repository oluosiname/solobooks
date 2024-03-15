# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      # t.references :client, null: false, foreign_key: true
      # t.references :invoice_template, null: false, foreign_key: true
      # t.references :currency, null: false, foreign_key: true
      # t.references :payment_term, null: false, foreign_key: true
      t.date :date, index: true
      t.date :due_date, index: true
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :status, default: 'pending', index: true

      t.timestamps
    end
  end
end
