class CreateUserTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tokens do |t|
      t.references :user, foreign_key: true, null: false
      t.string :service, null: false
      t.string :access_token, null: false
      t.string :refresh_token
      t.datetime :expires_at
      t.timestamps
    end
  end
end
