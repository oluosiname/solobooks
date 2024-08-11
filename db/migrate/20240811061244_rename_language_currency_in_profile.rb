class RenameLanguageCurrencyInProfile < ActiveRecord::Migration[7.1]
  def change
    rename_column :profiles, :language, :invoice_language
    rename_column :profiles, :currency_id, :invoice_currency_id
  end
end
