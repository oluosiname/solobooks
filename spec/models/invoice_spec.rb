# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  subject { build(:invoice, user: create(:user)) }

  describe 'Associations' do
    it { is_expected.to belong_to(:invoice_category) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:client) }
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to belong_to(:currency) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_uniqueness_of(:invoice_number).scoped_to(:user_id) }
  end

  describe '#generate_invoice_number' do
    let(:invoice) { create(:invoice, user:) }
    let(:user) { create(:user) }

    before do
      Timecop.freeze('2024-04-01')
    end

    after do
      Timecop.return
    end

    it "combines 'INV', year date of the invoice, and the id of the invoice" do
      expect(invoice.invoice_number).to eq('INV-2024-04-01')
    end

    context 'when first invoice of month' do
      it 'generates first invoice' do
        expect(invoice.invoice_number).to eq('INV-2024-04-01')
      end
    end

    context 'when less than 1000 invoices have been created' do
      it 'pads the id with leading zeros' do
        expect(invoice.invoice_number).to eq("INV-#{Time.zone.now.year}-04-01")
      end
    end

    context 'when user has previous invoices for current month' do
      before do
        allow(user.invoices).to receive(:created_in_current_month).and_return([1, 2, 3])
      end

      it 'uses appropriate suffix' do
        expect(invoice.invoice_number).to eq("INV-#{Time.zone.now.year}-04-04")
      end
    end
  end

  describe '.filtered' do
    let(:status) { 'cancelled' }
    let(:client_id) { create(:client).id }

    context 'when no params passed' do
      it 'returns all records' do
        invoices = create_list(:invoice, 3, status:, client_id:)
        expect(described_class.filtered(nil)).to match_array(invoices)
        expect(described_class.filtered(nil)).not_to be_empty
      end
    end

    it 'filters by status when status param is provided' do
      filtered_records = create_list(:invoice, 3, status:)
      create(:invoice, status: 'sent') # Create a record with different status

      expect(described_class.filtered({ status: })).to match_array(filtered_records)
    end

    it 'filters by client_id when client_id param is provided' do
      filtered_records = create_list(:invoice, 3, client_id:)
      create(:invoice, client: create(:client)) # Create a record with different client_id

      expect(described_class.filtered({ client_id: })).to match_array(filtered_records)
    end

    it 'filters by both status and client_id when both params are provided' do
      filtered_records = create_list(:invoice, 3, status:, client_id:)
      create(:invoice, status:, client: create(:client)) # Create a record with same status but different client_id
      create(:invoice, client_id:, status: 'sent') # Create a record with same client_id but different status
      create(:invoice) # Create a record with different status and client_id
      expect(described_class.filtered({ status:, client_id: })).to match_array(filtered_records)
    end
  end

  describe '.filter_by_status' do
    it 'filters records by status when status is present' do
      status = 'sent'
      filtered_records = create_list(:invoice, 3, status:)
      create(:invoice, status: 'paid') # Create a record with different status
      expect(described_class.filter_by_status(status)).to match_array(filtered_records)
    end

    it 'returns all records when status is not present' do
      create_list(:invoice, 3)
      expect(described_class.filter_by_status(nil)).to match_array(described_class.all)
    end
  end

  describe '.filter_by_client' do
    let!(:client) { create(:client) }

    it 'filters records by client_id when client_id is present' do
      client_id = client.id
      filtered_records = create_list(:invoice, 3, client_id:)
      create(:invoice, client: create(:client)) # Create a record with different client_id
      expect(described_class.filter_by_client(client_id)).to match_array(filtered_records)
    end

    it 'returns all records when client_id is not present' do
      create_list(:invoice, 3)
      expect(described_class.filter_by_client(nil)).to match_array(described_class.all)
    end
  end
end
