# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payment Detail', type: :system do
  let!(:user) { create(:user) }

  before do
    login_user(user)
  end

  describe 'Setting Payment detail' do
    context 'with valid data' do
      it 'sets user payment detail' do
        visit '/settings'

        fill_in 'payment_detail[iban]', with: 'IBAN'
        fill_in 'payment_detail[bank_name]', with: Faker::Bank.name
        fill_in 'payment_detail[account_holder]', with: Faker::Name.name
        fill_in 'payment_detail[swift]', with: Faker::Bank.swift_bic
        fill_in 'payment_detail[account_number]', with: Faker::Bank.account_number(digits: 10)
        fill_in 'payment_detail[sort_code]', with: Faker::Bank.account_number
        fill_in 'payment_detail[routing_number]', with: Faker::Bank.routing_number

        click_on 'Save'

        expect(page).to have_content('Payment Detail was created successfully')
      end
    end

    context 'with invalid data' do
      it 'displays error messages' do
        visit '/settings'

        click_on 'Save'

        expect(page).to have_content('4 errors prohibited this Payment detail from being saved')
        expect(page).to have_content("IBAN can't be blank")
        expect(page).to have_content("Bank name can't be blank")
        expect(page).to have_content("Account holder can't be blank")
        expect(page).to have_content("Account number can't be blank")
      end
    end

    context 'when user has no payment detail' do
      it 'creates a new payment detail' do
        visit '/settings'

        fill_in 'payment_detail[iban]', with: 'IBAN'
        fill_in 'payment_detail[bank_name]', with: Faker::Bank.name
        fill_in 'payment_detail[account_holder]', with: Faker::Name.name
        fill_in 'payment_detail[swift]', with: Faker::Bank.swift_bic
        fill_in 'payment_detail[account_number]', with: Faker::Bank.account_number(digits: 10)
        fill_in 'payment_detail[sort_code]', with: Faker::Bank.account_number
        fill_in 'payment_detail[routing_number]', with: Faker::Bank.routing_number

        expect { click_on 'Save' }.to change { user.reload.payment_detail }.from(nil).to(PaymentDetail)
      end
    end

    context 'when user has a payment detail' do
      it 'updates existing payment detail' do
        visit '/settings'

        fill_in 'payment_detail[iban]', with: 'IBAN'
        fill_in 'payment_detail[bank_name]', with: Faker::Bank.name
        fill_in 'payment_detail[account_holder]', with: Faker::Name.name
        fill_in 'payment_detail[swift]', with: Faker::Bank.swift_bic
        fill_in 'payment_detail[account_number]', with: Faker::Bank.account_number(digits: 10)
        fill_in 'payment_detail[sort_code]', with: Faker::Bank.account_number
        fill_in 'payment_detail[routing_number]', with: Faker::Bank.routing_number

        expect { click_on 'Save' }.not_to change(user, :payment_detail)
      end
    end
  end
end
