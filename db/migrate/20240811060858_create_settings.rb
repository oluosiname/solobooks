class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :language
      t.string :currency
      t.belongs_to :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
