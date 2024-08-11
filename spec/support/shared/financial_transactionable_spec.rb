# frozen_string_literal: true

RSpec.shared_examples 'Financial Transaction' do |_parameter|
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:transaction_type) }

    it 'validates the content type of the receipt' do
      expect(subject).to validate_content_type_of(:receipt).allowing(*FinancialTransaction::ACCEPTABLE_RECEIPT_FORMATS)
    end

    it 'validates the size of the receipt' do
      expect(subject).to validate_size_of(:receipt).less_than_or_equal_to(FinancialTransaction::MAX_RECEIPT_SIZE)
    end
  end

  describe '#income?' do
    it 'returns true if transaction_type is Income' do
      subject.transaction_type = 'Income'
      expect(subject.income?).to be(true)
    end

    it 'returns false if transaction_type is not Income' do
      subject.transaction_type = 'Expense'
      expect(subject.income?).to be(false)
    end
  end

  describe '#expense?' do
    it 'returns true if transaction_type is Expense' do
      subject.transaction_type = 'Expense'
      expect(subject.expense?).to be(true)
    end

    it 'returns false if transaction_type is not Expense' do
      subject.transaction_type = 'Income'
      expect(subject.expense?).to be(false)
    end
  end
end

RSpec.shared_examples 'Financial Transaction Creation' do |transaction_type|
  describe 'creating financial transaction' do
    let(:description) { 'Test Transaction' }
    let(:receipt_path) { Rails.root.join('spec/fixtures/files/test_receipt.pdf') }

    it 'creates a new financial transaction' do
      visit transactions_path

      click_on "Add #{transaction_type.capitalize}"
      fill_in "#{transaction_type}[amount]", with: Faker::Number.decimal(l_digits: 2)
      fill_in "#{transaction_type}[description]", with: description
      fill_in "#{transaction_type}[date]", with: Faker::Date.between(from: 1.year.ago, to: Time.zone.today)
      attach_file "#{transaction_type}[receipt]", receipt_path

      click_on 'Save'

      expect(page).to have_content("#{transaction_type.capitalize} was successfully created.")
      within('#transactions-list') do
        expect(page).to have_content('Test Transaction')
      end
    end
  end
end

RSpec.shared_examples 'Financial Transaction Update' do |transaction_type|
  describe 'updating financial transaction' do
    let!(:financial_transaction) do
      create(
        :financial_transaction,
        transaction_type: transaction_type.capitalize,
        user:,
        description: 'old description',
      )
    end
    let(:new_description) { 'Updated Test Transaction' }

    it 'updates an existing financial transaction', :js do
      visit transactions_path

      within "#transaction-#{financial_transaction.id}" do
        click_on 'View'
      end
      fill_in "#{transaction_type}[description]", with: new_description

      click_on 'Save'

      expect(page).to have_content("#{transaction_type.capitalize} was successfully updated.")
      within('#transactions-list') do
        expect(page).to have_content(new_description)
      end
    end
  end
end
