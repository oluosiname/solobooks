# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :business_name
      t.string :business_tax_id
      t.string :vat_number
      t.timestamps
    end
  end
end
