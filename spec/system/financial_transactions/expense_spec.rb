# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expense', type: :system do
  describe 'creating expense' do
    before do
      user = create(:user, :confirmed)
      create(:profile, user:)
      login_user(user)
    end

    it_behaves_like 'Financial Transaction Creation', 'expense'

    it 'allows users to Login' do
      visit transactions_path

      click_on 'Add Expense'

      fill_in 'expense[amount]', with: Faker::Number.decimal(l_digits: 2)
      fill_in 'expense[description]', with: 'Test Expense'
      fill_in 'expense[date]', with: Faker::Date.between(from: 1.year.ago, to: Time.zone.today)
      click_on 'Save'

      expect(page).to have_content('Expense was successfully created')
      expect(page).to have_current_path(transactions_path)
    end

    context 'with invalid data' do
      it 'displays error messages' do
        visit transactions_path

        click_on 'Add Expense'

        fill_in 'expense[amount]', with: Faker::Number.decimal(l_digits: 2)
        click_on 'Save'

        expect(page).to have_content('1 error prohibited this Expense from being saved')
        expect(page).to have_content("Date can't be blank")
      end
    end
  end
end
