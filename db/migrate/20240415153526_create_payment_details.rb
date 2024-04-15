# frozen_string_literal: true

class CreatePaymentDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_details do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bank_name
      t.string :iban
      t.string :swift
      t.string :account_number
      t.string :sort_code
      t.string :routing_number
      t.string :account_holder
      t.timestamps
    end
  end
end
