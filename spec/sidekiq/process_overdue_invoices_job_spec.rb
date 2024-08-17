# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ProcessOverdueInvoicesJob, type: :job do
  describe '#perform' do
    let(:invoice) { create(:invoice, status:, due_date: Time.zone.today) }
    let(:status)  { 'sent' }

    before do
      allow(invoice).to receive(:mark_overdue).and_call_original
      Timecop.freeze(2.days.from_now)
    end

    it 'marks overdue invoices' do
      expect { described_class.new.perform }.to change { invoice.reload.status }.from('sent').to('overdue')
    end

    context 'when invoice is overdue' do
      let(:status) { 'overdue' }

      it 'does not mark overdue invoices that are already overdue' do
        expect { described_class.new.perform }.not_to change { invoice.reload.status }

        expect(invoice).not_to have_received(:mark_overdue)
      end
    end

    context 'when invoice is not in sent status' do
      let(:status) { Invoice.statuses.except('sent').keys.sample }

      it 'does not mark the invoice as overdue' do
        expect { described_class.new.perform }.not_to change { invoice.reload.status }
      end
    end

    context 'when invoice is paid' do
      let(:status) { 'paid' }

      it 'does not mark the invoice as overdue' do
        expect { described_class.new.perform }.not_to change { invoice.reload.status }
      end
    end
  end
end
