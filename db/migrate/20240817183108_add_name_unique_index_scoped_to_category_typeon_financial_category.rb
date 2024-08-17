class AddNameUniqueIndexScopedToCategoryTypeonFinancialCategory < ActiveRecord::Migration[7.1]
  def change
    add_index :financial_categories, [:name, :category_type], unique: true
  end
end
