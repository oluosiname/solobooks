# frozen_string_literal: true

module TransactionsHelper
  CATEGORY_ICONS = {
  "service_fees" => "fas fa-briefcase",            # Service Fees / Consulting Fees
  "project_based_income" => "fas fa-project-diagram",  # Project-Based Income
  "royalties" => "fas fa-crown",                   # Royalties
  "product_sales" => "fas fa-shopping-cart",       # Product Sales
  "commissions" => "fas fa-percentage",            # Commissions
  "rental_income" => "fas fa-home",                # Rental Income (Business-Related)
  "subsidies_grants" => "fas fa-hand-holding-usd", # Subsidies / Grants
  "miscellaneous_income" => "fas fa-coins",        # Miscellaneous Income
  
  "office_supplies" => "fas fa-pencil-ruler",      # Office Supplies
  "software_tools" => "fas fa-laptop-code",        # Software & Tools
  "telecommunication_costs" => "fas fa-phone",     # Telecommunication Costs
  "rent_office_space" => "fas fa-building",        # Rent / Office Space
  "utilities" => "fas fa-bolt",                    # Utilities
  "travel_expenses" => "fas fa-plane",             # Travel Expenses
  "professional_fees" => "fas fa-gavel",           # Professional Fees
  "marketing_advertising" => "fas fa-bullhorn",    # Marketing & Advertising
  "insurance" => "fas fa-shield-alt",              # Insurance
  "training_education" => "fas fa-chalkboard-teacher", # Training & Education
  "depreciation" => "fas fa-chart-line",           # Depreciation
  "bank_fees" => "fas fa-piggy-bank",              # Bank Fees
  "client_entertainment" => "fas fa-utensils",     # Client Entertainment
  "office_furniture_equipment" => "fas fa-chair",  # Office Furniture & Equipment
  "freelance_subcontractors" => "fas fa-users",    # Freelance Subcontractors
  "taxes_social_contributions" => "fas fa-file-invoice-dollar", # Taxes & Social Contributions
  "membership_fees" => "fas fa-id-card",           # Membership Fees
  "licenses_permits" => "fas fa-file-contract",    # Licenses & Permits
  "gifts" => "fas fa-gift",                        # Gifts
  "miscellaneous_expenses" => "fas fa-receipt",    # Miscellaneous Expenses
  "meals_business_trips" => "fas fa-hamburger",    # Meals for Business Trips
  "accommodation_business_trips" => "fas fa-bed",  # Accommodation for Business Trips
  "transportation_business_trips" => "fas fa-car", # Transportation for Business Trips
  "materials_used_products" => "fas fa-box",       # Materials Used for Products
  "private_car_usage" => "fas fa-car-side",        # Private Car Usage
  "back_payment_corona_aid" => "fas fa-exclamation-triangle", # Back Payment of Corona Aid
  "private_expenses" => "fas fa-user-shield"       # Private Expenses (Non-Business Related)
}

  def format_transaction_amount(transaction)
    amount = number_to_currency(transaction.amount, unit: profile.invoice_currency.symbol)
    transaction.income? ? "+ #{amount}" : "- #{amount}"
  end

  def color_transaction_amount(transaction)
    transaction.income? ? 'text-green-600' : 'text-danger-700'
  end

  def transaction_receipt_icon(content_type)
    case content_type
    when 'image/jpeg', 'image/png'
      'fa-file-image'
    when 'application/pdf'
      'fa-file-pdf'
    else
      'fa-file'
    end
  end

  # def category_options(categories)
  #   categories.map do |cat|
  #     icon = CATEGORY_ICONS[cat.name]
  #     ["<i class='#{icon}'></i> sss #{cat.translated_name}".html_safe, cat.id]
  #   end
  # end
end
