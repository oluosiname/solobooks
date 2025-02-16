# frozen_string_literal: true

original_locale = Faker::Config.locale
Faker::Config.locale = 'de'

7.times do
  BankConnection.create(
    bank_name: Faker::Bank.name,
    account_id: SecureRandom.hex(8),
    account_number: Faker::Bank.account_number,
    status: 'active',
    connection_service: 'gocardless',
    last_sync_at: Faker::Time.between(from: 4.days.ago, to: Time.current),
    user_id: User.last.id,
  )
end

Faker::Config.locale = original_locale
