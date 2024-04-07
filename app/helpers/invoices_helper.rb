# frozen_string_literal: true

module InvoicesHelper
  def category_options(categories)
    categories.map { |category| [category.name.capitalize, category.id] }
  end

  def client_options(clients)
    clients.map { |c| [c.name.capitalize, c.id] }
  end
end
