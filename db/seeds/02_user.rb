# frozen_string_literal: true

return unless Rails.env.development?

# Clear previous data
User.destroy_all

user = User.create!(
  email: 'dev@solobooks.de',
  password: 'password123',
  password_confirmation: 'password123',
  confirmed_at: Time.zone.now,
)

FactoryBot.create(:profile, user:)

FactoryBot.create(:payment_detail, user:)
