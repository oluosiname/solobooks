# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :legal_status, null: false
      t.string :full_name, null: false
      t.string :phone_number
      t.date :date_of_birth
      t.string :nationality
      t.string :country
      t.string :business_name
      t.string :tax_number
      t.string :vat_id
      t.references :currency
      t.string :language
      t.timestamps
    end
  end
end
