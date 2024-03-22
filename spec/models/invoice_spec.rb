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
      invoice = create(:invoice, id: 5)

      expect(invoice.invoice_number).to eq("INV/2024/00#{invoice.id}")
    end

    context 'when invoice id is less than 1000' do
      it 'pads the id with leading zeros' do
        invoice = create(:invoice, id: 5)

        expect(invoice.invoice_number).to eq("INV/#{Time.zone.now.year}/005")
      end
    end
  end

  describe '.filtered' do
    let(:status) { 'cancelled' }
    let(:client_id) { create(:client).id }

    context 'when no params passed' do
      it 'returns all records' do
        invoices = create_list(:invoice, 3)
        expect(described_class.filtered(nil)).to match_array(invoices)
        expect(described_class.filtered(nil)).not_to be_empty
      end
    end

    it 'filters by status when status param is provided' do
      filtered_records = create_list(:invoice, 3, status:)
      create(:invoice, status: 'pending') # Create a record with different status

      expect(described_class.filtered({ status: })).to eq(filtered_records)
    end

    it 'filters by client_id when client_id param is provided' do
      filtered_records = create_list(:invoice, 3, client_id:)
      create(:invoice, client: create(:client)) # Create a record with different client_id

      expect(described_class.filtered({ client_id: })).to eq(filtered_records)
    end

    it 'filters by both status and client_id when both params are provided' do
      filtered_records = create_list(:invoice, 3, status:, client_id:)
      create(:invoice, status:, client: create(:client)) # Create a record with same status but different client_id
      create(:invoice, client_id:, status: 'pending') # Create a record with same client_id but different status
      create(:invoice) # Create a record with different status and client_id
      expect(described_class.filtered({ status:, client_id: })).to eq(filtered_records)
    end
  end

  describe '.filter_by_status' do
    it 'filters records by status when status is present' do
      status = 'pending'
      filtered_records = create_list(:invoice, 3, status:)
      create(:invoice, status: 'paid') # Create a record with different status
      expect(described_class.filter_by_status(status)).to eq(filtered_records)
    end

    it 'returns all records when status is not present' do
      create_list(:invoice, 3)
      expect(described_class.filter_by_status(nil)).to eq(described_class.all)
    end
  end

  describe '.filter_by_client' do
    let(:client) { create(:client) }

    it 'filters records by client_id when client_id is present' do
      client_id = client.id
      filtered_records = create_list(:invoice, 3, client_id:)
      create(:invoice, client: create(:client)) # Create a record with different client_id
      expect(described_class.filter_by_client(client_id)).to eq(filtered_records)
    end

    it 'returns all records when client_id is not present' do
      create_list(:invoice, 3)
      expect(described_class.filter_by_client(nil)).to eq(described_class.all)
    end
  end
end
