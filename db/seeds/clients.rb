# frozen_string_literal: true

10.times do
  client = Client.new(
    name: Faker::Company.name,
    email: Faker::Internet.email,
    phone_number: Faker::PhoneNumber.phone_number,
    vat_number: Faker::Number.number(digits: 9),
    user: User.first,
  )

  address = Address.new(
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    postal_code: Faker::Address.zip_code,
    country: 'Germany',
  )

  client.address = address
  client.save!
end
