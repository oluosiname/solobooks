# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Income', type: :system do
  let(:user) { create(:user, :confirmed) }
  let(:category) { create(:financial_category, category_type: 'income') }

  before do
    create(:profile, user:)
    login_user(user)
    allow(FinancialCategory).to receive_message_chain(:income, :order).and_return([category])
    allow(category).to receive(:translated_name).and_return('Test Category')
  end

  describe 'creating income' do
    it_behaves_like 'Financial Transaction Creation', 'income'

    it 'allows users to Login' do
      visit transactions_path

      click_on 'Add Income'

      fill_in 'income[amount]', with: Faker::Number.decimal(l_digits: 2)
      fill_in 'income[description]', with: 'Test Income'
      fill_in 'income[date]', with: Faker::Date.between(from: 1.year.ago, to: Time.zone.today)
      click_on 'Save'

      expect(page).to have_content('Income was successfully created')
      expect(page).to have_current_path(transactions_path)
    end

    context 'with invalid data' do
      it 'displays error messages' do
        visit transactions_path

        click_on 'Add Income'

        fill_in 'income[amount]', with: Faker::Number.decimal(l_digits: 2)
        click_on 'Save'

        expect(page).to have_content('1 error prohibited this Income from being saved')
        expect(page).to have_content("Date can't be blank")
      end
    end
  end

  describe 'updating income' do
    it_behaves_like 'Financial Transaction Update', 'income'
  end
end
