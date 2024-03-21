# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:invoice_category) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe '#generate_invoice_number' do
    it "combines 'INV', year date of the invoice, and the id of the invoice" do
      invoice = create(:invoice)

      expect(invoice.invoice_number).to eq("INV/2024/00#{invoice.id}")
    end

    context 'when invoice id is less than 1000' do
      it 'pads the id with leading zeros' do
        invoice = create(:invoice, id: 5)

        expect(invoice.invoice_number).to eq("INV/#{Time.zone.now.year}/005")
      end
    end
  end
end
