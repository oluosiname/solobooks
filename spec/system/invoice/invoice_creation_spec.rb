# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invoice Creation', type: :system do
  let!(:user) { create(:user, :with_profile) }
  let!(:client) { create(:client, user:) }
  let!(:invoice_category) { create(:invoice_category) }
  let!(:currency) { create(:currency, :default) }

  before do
    create(:payment_detail, user:)
    client.address.update(country: 'DE')
    login_user(user)
  end

  describe 'visiting invoice creation page' do
    before { login_user(user) }

    context 'when user has complete profile and payment detail' do
      it 'shows invoice creation form' do
        visit 'invoices/new'

        expect(page).to have_current_path('/invoices/new')
        expect(page).to have_content('New Invoice')
      end
    end

    context 'when user has no profile' do
      let(:user) { create(:user) } # user without profile

      it 'redirects back to invoice page' do
        visit 'invoices/new'

        expect(page).to have_current_path(invoices_path)
        expect(page).to have_content('Please fill out your profile and payment detail before creating an invoice')
      end
    end

    context "when user's profile is incomplete" do
      before do
        allow(user.profile).to receive(:complete?).and_return(false)
      end

      it 'redirects back to invoice page' do
        visit 'invoices/new'

        expect(page).to have_current_path(invoices_path)
        expect(page).to have_content('Please fill out your profile and payment detail before creating an invoice')
      end
    end
  end

  context 'when valid data' do
    it 'creates invoice', :js do
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

  describe 'vat calculation' do
    let(:user) { create(:user) }
    let(:client_country) { 'DE' }
    let(:user_country) { 'DE' }

    before do
      client.address.update(country: client_country)
      create(:profile, country: user_country, user:)
      visit new_invoice_path
    end

    context 'when vat is chargeable' do
      it 'displays VAT field', :js do
        select client.name, from: 'invoice[client_id]'

        expect(page).to have_field(id: 'invoice_vat_rate')
        expect(page).to have_field(id: 'invoice_vat')
        expect(page).to have_field(id: 'invoice_vat')
      end

      context 'when vat is included in price' do
        it 'separates VAT from subtotal', :js do
          select client.name, from: 'invoice[client_id]'
          fill_in 'invoice[line_items_attributes][0][quantity]', with: 2
          fill_in 'invoice[line_items_attributes][0][unit_price]', with: 100

          find('label', text: 'VAT included in price').click

          select '19%', from: 'invoice[vat_rate]'

          expect(page).to have_text(/Subtotal\s*€162\.00/)
          expect(page).to have_field('invoice[vat]', with: '38')
          expect(page).to have_text(/Total\s*€200\.00/)
        end
      end

      context 'when VAT is not included in price' do
        it 'adds VAT to subtotal', :js do
          select client.name, from: 'invoice[client_id]'
          fill_in 'invoice[line_items_attributes][0][quantity]', with: 2
          fill_in 'invoice[line_items_attributes][0][unit_price]', with: 100

          select '19%', from: 'invoice[vat_rate]'

          expect(page).to have_text(/Subtotal\s*€200\.00/)
          expect(page).to have_field('invoice[vat]', with: '38')
          expect(page).to have_text(/Total\s*€238\.00/)
        end
      end
    end

    context 'when VAT is not chargeable' do
      let(:client_country) { 'FR' }

      it 'does not display VAT field', :js do
        select client.name, from: 'invoice[client_id]'

        expect(page).to have_no_field(id: 'invoice_vat_rate')
        expect(page).to have_no_field(id: 'invoice_vat')
        expect(page).to have_no_field(id: 'invoice_vat')
      end

      context 'when EU country' do
        let(:client_country) { 'FR' }

        it 'displays VAT message', :js do
          select client.name, from: 'invoice[client_id]'

          expect(page).to have_content('Reverse VAT charge is applied (§13b Abs. 5 UStG)')
        end
      end

      context 'when non-EU country' do
        let(:client_country) { 'US' }

        it 'displays VAT message', :js do
          select client.name, from: 'invoice[client_id]'
          expect(page).to have_content('You can not charge VAT for non-EU clients')
        end
      end

      context 'when tax exempt' do
        before do
          user.profile.update(vat_id: nil)
        end

        it 'displays VAT message', :js do
          select client.name, from: 'invoice[client_id]'
          expect(page).to have_content('According to § 19 UStG no sales tax is charged.')
        end
      end
    end
  end

  describe 'filling in line items' do
    context 'when filling in line item price' do
      it 'calucates total price', :js do
        visit 'invoices/new'
        fill_in 'invoice[line_items_attributes][0][quantity]', with: 2
        fill_in 'invoice[line_items_attributes][0][unit_price]', with: 100

        expect(page).to have_field('invoice[line_items_attributes][0][total_price]', with: '200')
      end

      context 'when invalid price' do
        it 'shows field as invalid', :js do
          visit 'invoices/new'

          fill_in 'invoice[line_items_attributes][0][quantity]', with: 2
          fill_in 'invoice[line_items_attributes][0][unit_price]', with: '100.'

          expect(page).to have_field('invoice[line_items_attributes][0][unit_price]', with: '')
          within '.invoice-line-item-fields-wrapper' do
            expect(page).to have_css('.invalid-feedback')
          end
        end
      end
    end
  end
end
