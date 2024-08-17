# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expense', type: :system do
  let(:user) { create(:user, :confirmed) }
  let(:category) { create(:financial_category, category_type: 'expense') }

  before do
    create(:profile, user:)
    login_user(user)
    allow(FinancialCategory).to receive_message_chain(:expense, :order).and_return([category])
    allow(category).to receive(:translated_name).and_return('Test Category')
  end

  describe 'creating expense' do
    it_behaves_like 'Financial Transaction Creation', 'expense'

    it 'creates expense' do
      visit transactions_path

      click_on 'Add Expense'

      fill_in 'expense[amount]', with: Faker::Number.decimal(l_digits: 2)
      fill_in 'expense[description]', with: 'Test Expense'
      fill_in 'expense[date]', with: Faker::Date.between(from: 1.year.ago, to: Time.zone.today)
      select 'Test Category', from: 'expense[financial_category_id]'
      click_on 'Save'

      expect(page).to have_content('Expense was successfully created')
      expect(page).to have_current_path(transactions_path)
      expect(Expense.last.description).to eq('Test Expense')
      expect(Expense.last.category).to eq(category)
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

  describe 'updating expense' do
    it_behaves_like 'Financial Transaction Update', 'expense'
  end
end
