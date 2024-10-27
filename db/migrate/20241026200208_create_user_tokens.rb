class CreateUserTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.string :service

      t.timestamps
    end

    add_index :user_tokens, [:service, :user_id], unique: true
  end
end
