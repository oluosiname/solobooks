# frozen_string_literal: true

return unless Rails.env.development?

transaction_types = ['Income', 'Expense']

# Set the date range
start_date = Date.new(2023, 12, 12)
end_date = Date.new(2024, 8, 17)

# Create 50 FinancialTransaction records
100.times do
  has_receipt = [true, false].sample
  transaction_type = transaction_types.sample
  transaction = FinancialTransaction.create!(
    user: User.all.sample, # Assuming there are existing users in the database
    amount: Faker::Number.decimal(l_digits: 2),
    description: Faker::Lorem.sentence(word_count: 5),
    date: Faker::Date.between(from: start_date, to: end_date),
    transaction_type:,
    category: FinancialCategory.send(transaction_type.downcase).sample,
  )

  next unless has_receipt

  file_extension = ['png', 'pdf'].sample
  file_path = Rails.root.join("spec/fixtures/files/test_receipt.#{file_extension}")
  transaction.receipt.attach(
    io: File.open(file_path),
    filename: "test_receipt.#{file_extension}",
    content_type: file_extension == 'pdf' ? 'attachment/pdf' : "image/#{file_extension}",
  )
end
