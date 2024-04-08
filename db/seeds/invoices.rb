# frozen_string_literal: true

return unless Rails.env.development?

user = User.first
Invoice.destroy_all

100.times do
  date = Faker::Date.between(from: Date.today, to: 1.year.from_now)
  due_date = date + Faker::Number.between(from: 1, to: 30).days
  Invoice.create!(
    user: user,
    date: , 
    due_date: ,
    total_amount: Faker::Number.decimal(l_digits: 3, r_digits: 2),
    status: Invoice.statuses.keys.sample,
    invoice_category: InvoiceCategory.all.sample,
    client: Client.all.sample,
    currency: Currency.active.sample,
    language: Invoice::LANGUAGES.values.sample,
    vat_rate: Invoice::VAT_RATES.values.sample,
    vat_included: [true, false].sample,
    line_items: Faker::Number.between(from: 1, to: 7).times.map do
      LineItem.new(
        description: Faker::Lorem.sentence,
        quantity: Faker::Number.between(from: 1, to: 10),
        unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2),
        unit: Faker::Lorem.word,
      )
    end,
  )
end

puts 'Invoices created'
