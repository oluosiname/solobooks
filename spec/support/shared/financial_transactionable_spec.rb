# frozen_string_literal: true

RSpec.shared_examples 'Financial Transaction' do |_parameter|
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:transaction_type) }
  end
end

RSpec.shared_examples 'Financial Transaction Creation' do |transaction_type|
  describe 'creating financial transaction' do
    let(:description) { 'Test Transaction' }

    it 'creates a new financial transaction' do
      visit transactions_path

      click_on "Add #{transaction_type.capitalize}"
      fill_in "#{transaction_type}[amount]", with: Faker::Number.decimal(l_digits: 2)
      fill_in "#{transaction_type}[description]", with: description
      fill_in "#{transaction_type}[date]", with: Faker::Date.between(from: 1.year.ago, to: Time.zone.today)

      click_on 'Save'

      expect(page).to have_content("#{transaction_type.capitalize} was successfully created.")
      within('#transactions-list') do
        expect(page).to have_content('Test Transaction')
      end
    end
  end
end
