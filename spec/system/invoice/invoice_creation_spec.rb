# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoice Creation', type: :system do
  let!(:user) { create(:user, :with_profile) }
  let!(:client) { create(:client, user:) }
  let!(:invoice_category) { create(:invoice_category) }
  let!(:currency) { create(:currency, default: true) }

  before do
    create(:payment_detail, user:)
  end

  context 'when valid data' do
    it 'creates invoice', :js do
      login_user(user)
      visit 'invoices/new'
      expect(user.invoices.size).to eq(0)

      select invoice_category.name.capitalize, from: 'invoice[invoice_category_id]'
      select currency.code, from: 'invoice[currency_id]'
      select client.name, from: 'invoice[client_id]'
      find('.invoice_date_container').click
      within('.dayContainer') do
        find('span.today').click
      end
      find('.invoice_due_date_container').click
      within('.dayContainer') do
        first('span.flatpickr-day', text: Time.zone.today.day.to_i + 1, exact_text: true).click
      end

      fill_in 'invoice[line_items_attributes][0][description]', with: 'First item description'
      fill_in 'invoice[line_items_attributes][0][quantity]', with: 2
      fill_in 'invoice[line_items_attributes][0][unit_price]', with: 100
      click_on 'Save'

      expect(page).to have_current_path(invoices_path)
      # expect(page).to have_content('Invoice was successfully created.')

      expect(user.invoices.reload.size).to eq(1)
      last_invoice = user.invoices.last

      expect(last_invoice.invoice_category).to eq(invoice_category)
      expect(last_invoice.currency).to eq(currency)
      expect(last_invoice.client).to eq(client)
      expect(last_invoice.vat_rate).to eq(0)
      expect(last_invoice.vat).to eq(0)
      expect(last_invoice.vat_included).to be(false)
      expect(last_invoice.date).to eq(Time.zone.today)
      expect(last_invoice.due_date).to eq(Time.zone.today + 1.day)
      expect(last_invoice.line_items.size).to eq(1)
      expect(last_invoice.line_items.first.description).to eq('First item description')
      expect(last_invoice.line_items.first.quantity).to eq(2)
      expect(last_invoice.line_items.first.unit_price).to eq(100)
      expect(last_invoice.line_items.first.total_price).to eq(200)
      expect(last_invoice.subtotal).to eq(200)
      expect(last_invoice.total_amount).to eq(200)
      expect(last_invoice.status).to eq('pending')
      expect(last_invoice.pdf.attached?).to be(true)
    end
  end
end
