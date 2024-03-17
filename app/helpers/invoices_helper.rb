# frozen_string_literal: true

module InvoicesHelper
  def category_options(categories)
    categories.map { |category| [category.name.capitalize, category.id] }
  end
end
