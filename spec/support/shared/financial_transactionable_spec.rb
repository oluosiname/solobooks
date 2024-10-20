# frozen_string_literal: true

RSpec.shared_examples 'Financial Transaction' do |_parameter|
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    it 'calculates VAT before saving' do
      transaction = build(:financial_transaction, amount: 60, vat_rate: 19)
      transaction.save
      expect(transaction.vat_amount).to eq(9.58)
    end
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

  describe 'scopes' do
    let!(:income_transaction) { create(:income, date: '2023-06-01', description: 'Salary') }
    let!(:expense_transaction) { create(:expense, date: '2023-07-01', description: 'Groceries') }

    describe '.by_transaction_type' do
      it 'returns transactions of the specified type' do
        result = FinancialTransaction.by_transaction_type('income')
        expect(result).to contain_exactly(income_transaction)
      end

      it 'returns all transactions if no type is specified' do
        result = FinancialTransaction.by_transaction_type(nil)
        expect(result).to contain_exactly(income_transaction, expense_transaction)
      end
    end

    describe '.by_date' do
      it 'returns transactions within the specified date range' do
        result = FinancialTransaction.by_date('2023-06-01', '2023-06-30')
        expect(result).to contain_exactly(income_transaction)
      end

      it 'returns all transactions if no date range is specified' do
        result = FinancialTransaction.by_date(nil, nil)
        expect(result).to contain_exactly(income_transaction, expense_transaction)
      end

      it 'returns all transactions if only one date is specified' do
        result = FinancialTransaction.by_date('2023-06-01', nil)
        expect(result).to contain_exactly(income_transaction, expense_transaction)
      end
    end

    describe '.by_description' do
      it 'returns transactions matching the description (case insensitive)' do
        result = FinancialTransaction.by_description('salary')
        expect(result).to contain_exactly(income_transaction)
      end

      it 'returns all transactions if no description is specified' do
        result = FinancialTransaction.by_description(nil)
        expect(result).to contain_exactly(income_transaction, expense_transaction)
      end
    end

    describe '.filtered' do
      it 'applies all filters correctly' do
        params = {
          transaction_type: 'Expense',
          start_date: '2023-07-01',
          end_date: '2023-07-02',
          description: 'Gro',
        }

        result = FinancialTransaction.filtered(params)
        expect(result).to contain_exactly(expense_transaction)
      end

      it 'returns all transactions when no filters are applied' do
        params = {}
        result = FinancialTransaction.filtered(params)
        expect(result).to contain_exactly(income_transaction, expense_transaction)
      end
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
    let!(:category) { create(:financial_category, category_type: transaction_type) }

    before do
      allow(category).to receive(:translated_name).and_return('Test Category')
    end

    it 'creates a new financial transaction' do
      visit transactions_path

      click_on "Add #{transaction_type.capitalize}"
      fill_in "#{transaction_type}[amount]", with: Faker::Number.decimal(l_digits: 2)
      fill_in "#{transaction_type}[description]", with: description
      fill_in "#{transaction_type}[date]", with: Faker::Date.between(from: 1.year.ago, to: Time.zone.today)
      select 'Test Category', from: "#{transaction_type}[financial_category_id]"
      attach_file "#{transaction_type}[receipt]", receipt_path

      click_on 'Save'

      expect(page).to have_content("#{transaction_type.capitalize} was successfully created.")
      expect(page).to have_content('Test Transaction')
      expect(FinancialTransaction.last.description).to eq('Test Transaction')
      expect(FinancialTransaction.last.category).to eq(category)
      expect(FinancialTransaction.last.receipt).to be_attached
      expect(FinancialTransaction.last.receipt.filename).to eq('test_receipt.pdf')
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
      expect(page).to have_content(new_description)
    end
  end
end
