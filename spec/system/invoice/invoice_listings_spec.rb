# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoice Listing', type: :system do
  describe 'updating invoice status' do
    let!(:invoice) { create(:invoice, status:, user:) }
    let(:user) { create(:user) }

    before do
      login_user(user)
      visit invoices_path
    end

    shared_examples 'sendable invoice' do
      it 'allows sending an invoice', :js do
        within "#invoice-#{invoice.invoice_number}" do
          click_on(class: 'invoice-action-dropdown')
          click_on 'Mark as Sent'
        end

        expect(page).to have_content('Invoice sent successfully')
        expect(invoice.reload.status).to eq('sent')
      end
    end

    shared_examples 'payable invoice' do
      it 'allows marking invoice as paid', :js do
        within "#invoice-#{invoice.invoice_number}" do
          click_on(class: 'invoice-action-dropdown')
          click_on 'Mark as Paid'
        end

        expect(page).to have_content('Invoice was successfully marked as paid')
        expect(invoice.reload.status).to eq('paid')
      end
    end

    shared_examples 'cancellable invoice' do
      it 'allows cancelling invoice', :js do
        within "#invoice-#{invoice.invoice_number}" do
          click_on(class: 'invoice-action-dropdown')
          click_on 'Cancel'
        end

        expect(page).to have_content('Invoice cancelled')
        expect(invoice.reload.status).to eq('cancelled')
      end
    end

    shared_examples 'uncancellable invoice' do
      it 'does not allow cancelling invoice', :js do
        within "#invoice-#{invoice.invoice_number}" do
          click_on(class: 'invoice-action-dropdown')
          within '.dropdown-body' do
            expect(page).to have_no_content('Cancel')
          end
        end
      end
    end

    context 'when invoice is draft' do
      let(:status) { 'draft' }

      it_behaves_like 'sendable invoice'

      it_behaves_like 'payable invoice'

      it_behaves_like 'cancellable invoice'
    end

    context 'when invoice is sent' do
      let(:status) { 'sent' }

      it_behaves_like 'payable invoice'

      it_behaves_like 'cancellable invoice'
    end

    context 'when invoice is paid' do
      let(:status) { 'paid' }

      it_behaves_like 'uncancellable invoice'
    end

    context 'when invoice is cancelled' do
      let(:status) { 'cancelled' }

      it_behaves_like 'uncancellable invoice'
    end

    context 'when invoice is overdue' do
      let(:status) { 'overdue' }

      it_behaves_like 'payable invoice'
      it_behaves_like 'cancellable invoice'
    end
  end
end
