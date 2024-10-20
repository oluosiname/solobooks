# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VatCalculator do
  let(:user) { create(:user) }
  let(:start_date) { Date.new(2024, 1, 1) }
  let(:end_date) { Date.new(2024, 1, 31) }

  before do
    create(
      :income,
      user:,
      amount: 1000,
      date: Faker::Date.between(from: start_date, to: end_date),
    )
    create(
      :income,
      user:,
      amount: 2000,
      date: Faker::Date.between(from: start_date, to: end_date),
    )

    create(
      :expense,
      user:,
      amount: 500,
      date: Faker::Date.between(from: start_date, to: end_date),
    )
    create(
      :expense,
      user:,
      amount: 1000,
      date: Faker::Date.between(from: start_date, to: end_date),
    )
  end

  describe '#call' do
    subject(:result) { described_class.call(user:, start_date:, end_date:) }

    it 'calculates the correct total sales VAT' do
      expect(result[:total_sales_vat].to_f).to eq(478.99) # 159.66 + 319.33
    end

    it 'calculates the correct total expense VAT' do
      expect(result[:total_expense_vat]).to eq(239.49) # 159.66 + 79.83
    end

    it 'calculates the correct net VAT payable' do
      expect(result[:net_vat_payable]).to eq(239.5) # 478.99 - 239.49
    end

    context 'when there are no transactions within the date range' do
      subject(:result) { described_class.call(user:, start_date: start_date - 1.year, end_date: end_date - 1.year) }

      it 'returns zero for all VAT calculations' do
        expect(result[:total_sales_vat]).to eq(0)
        expect(result[:total_expense_vat]).to eq(0)
        expect(result[:net_vat_payable]).to eq(0)
      end
    end
  end
end
