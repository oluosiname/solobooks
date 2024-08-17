# frozen_string_literal: true

income_categories = [
  'service_fees',
  'project_based_income',
  'royalties',
  'product_sales',
  'commissions',
  'rental_income',
  'subsidies_grants',
  'miscellaneous_income',
]

expense_categories = [
  'office_supplies',
  'software_tools',
  'telecommunication_costs',
  'rent_office_space',
  'utilities',
  'travel_expenses',
  'professional_fees',
  'marketing_advertising',
  'insurance',
  'training_education',
  'depreciation',
  'bank_fees',
  'client_entertainment',
  'office_furniture_equipment',
  'freelance_subcontractors',
  'taxes_social_contributions',
  'membership_fees',
  'licenses_permits',
  'gifts',
  'miscellaneous_expenses',
  'meals_business_trips',
  'accommodation_business_trips',
  'transportation_business_trips',
  'materials_used_products',
  'private_car_usage',
  'back_payment_corona_aid',
  'private_expenses',
]

income_categories.each do |category|
  FinancialCategory.find_or_create_by(name: category, category_type: :income)
end

expense_categories.each do |category|
  FinancialCategory.find_or_create_by(name: category, category_type: :expense)
end
