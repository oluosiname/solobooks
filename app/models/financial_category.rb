class FinancialCategory < ApplicationRecord
  has_many :financial_transactions

  validates :name, presence: true, uniqueness: { scope: :category_type }
  validates :category_type, presence: true

  enum category_type: { income: 'income', expense: 'expense' }

  def translated_name
    I18n.t("activerecord.attributes.financial_category.#{category_type}.#{name}")
  end
end