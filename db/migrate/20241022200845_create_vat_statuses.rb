class CreateVatStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :vat_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :vat_registered, default: true
      t.string :declaration_period, default: 'monthly'
      t.date :starts_on
      t.boolean :kleinunternehmer, default: false
      t.string :tax_exempt_reason
      t.string :vat_number
      t.timestamps
    end
  end
end
