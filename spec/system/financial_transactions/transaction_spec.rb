# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions', type: :system do
  describe 'page' do
    before do
      create(:profile, user:)
      login_user(user)
    end

    let(:user) { create(:user, :confirmed) }
    let!(:income) { create(:income, user:) }
    let!(:expense) { create(:expense, user:) }

    it 'displays incomes and expenses' do
      visit transactions_path

      within('#transactions-list') do
        expect(page).to have_content(income.description)
        expect(page).to have_content(income.amount)
        expect(page).to have_content(income.date)
        expect(page).to have_content(expense.description)
        expect(page).to have_content(expense.amount)
        expect(page).to have_content(expense.date)
      end
    end

    it 'has link to create new transaction' do
      visit transactions_path

      expect(page).to have_link('Add Income', href: new_transaction_path(transaction_type: 'income'))
      expect(page).to have_link('Add Expense', href: new_transaction_path(transaction_type: 'expense'))
    end
  end

  describe 'deleting financial_transaction' do
    before { login_user(user) }

    let(:user) { create(:user, :with_profile) }
    let!(:financial_transaction) { create(:expense, user:) }

    it 'deletes a financial_transaction' do
      visit transactions_path

      within("#transaction-#{financial_transaction.id}") do
        click_on 'Delete'
      end

      expect(page).to have_current_path(transactions_path)
      expect(page).to have_content('Expense was successfully deleted')
    end

    context 'when financial_transaction is not deleted' do
      before do
        allow(financial_transaction).to receive(:destroy).and_return(false)
      end

      it 'displays an error message' do
        visit transactions_path

        within("#transaction-#{financial_transaction.id}") do
          click_on 'Delete'
        end

        expect(page).to have_content('Expense was successfully deleted')
      end
    end
  end
end
