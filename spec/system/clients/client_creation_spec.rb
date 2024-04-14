# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Client Creation', type: :system do
  let(:user) { create(:user, :confirmed) }

  before { login_user(user) }

  context 'when valid data' do
    it 'creates client', :js do
      visit 'clients/new'
      expect(user.clients.count).to eq(0)

      expect(page).to have_content('New Client')
      fill_in 'client[name]', with: 'John Doe'
      fill_in 'client[email]', with: Faker::Internet.email
      fill_in 'client[phone_number]', with: Faker::PhoneNumber.phone_number
      fill_in 'client[business_name]', with: Faker::Company.name
      fill_in 'client[business_tax_id]', with: Faker::Company.ein
      fill_in 'client[vat_number]', with: Faker::Number.number(digits: 9)
      fill_in 'client[address_attributes][street_address]', with: Faker::Address.street_address
      fill_in 'client[address_attributes][city]', with: Faker::Address.city
      fill_in 'client[address_attributes][postal_code]', with: Faker::Address.zip_code
      find(:select, 'client[address_attributes][country]').first(:option, 'Germany').select_option

      click_on 'Create'

      expect(page).to have_current_path(clients_path)
      expect(page).to have_content('Client was successfully created.')

      expect(user.clients.reload.count).to eq(1)
      last_client = user.clients.last

      expect(last_client.name).to eq('John Doe')
    end
  end

  context 'when invalid data' do
    it 'does not create client', :js do
      visit clients_path

      expect(page).to have_content('New Client')
      within('.page-heading') do
        click_button 'New Client' # rubocop:disable Capybara/ClickLinkOrButtonStyle
      end

      fill_in 'client[name]', with: ''
      fill_in 'client[email]', with: ''
      fill_in 'client[phone_number]', with: ''
      fill_in 'client[business_name]', with: ''
      fill_in 'client[business_tax_id]', with: ''
      fill_in 'client[vat_number]', with: ''
      click_on 'Create'

      expect(page).to have_content("Name can't be blank")
    end
  end

  context 'when creating from new invoice page' do
    before do
      create(:invoice_category)
      create(:currency, default: true)
    end

    it 'creates client', :js do
      visit new_invoice_path

      expect(page).to have_content('New')
      expect(page).to have_no_select('invoice[client_id]', with_options: ['John Doe'])
      click_on 'New'

      within('.modal') do
        fill_in 'client[name]', with: 'John Doe'
        fill_in 'client[email]', with: Faker::Internet.email
        fill_in 'client[phone_number]', with: Faker::PhoneNumber.phone_number
        fill_in 'client[business_name]', with: Faker::Company.name
        fill_in 'client[business_tax_id]', with: Faker::Company.ein
        fill_in 'client[vat_number]', with: Faker::Number.number(digits: 9)
        fill_in 'client[address_attributes][street_address]', with: Faker::Address.street_address
        fill_in 'client[address_attributes][city]', with: Faker::Address.city
        fill_in 'client[address_attributes][postal_code]', with: Faker::Address.zip_code
        find(:select, 'client[address_attributes][country]').first(:option, 'Germany').select_option

        click_on 'Create'
      end
      expect(page).to have_no_css('.modal')
      expect(page).to have_select('invoice[client_id]', with_options: ['John Doe'], selected: 'John Doe')
      expect(page).to have_current_path(new_invoice_path)
    end

    context 'when invalid data' do
      it 'displays error', :js do
        visit new_invoice_path

        click_on 'New'

        within('.modal') do
          fill_in 'client[name]', with: 'John Doe'
          fill_in 'client[email]', with: Faker::Internet.email
          fill_in 'client[phone_number]', with: Faker::PhoneNumber.phone_number
          fill_in 'client[business_name]', with: Faker::Company.name
          fill_in 'client[business_tax_id]', with: Faker::Company.ein
          fill_in 'client[vat_number]', with: Faker::Number.number(digits: 9)
          fill_in 'client[address_attributes][street_address]', with: Faker::Address.street_address

          click_on 'Create'
        end

        expect(page).to have_content("City can't be blank")
        expect(page).to have_content("Zip code can't be blank")
        expect(page).to have_current_path(new_invoice_path)
      end
    end
  end
end
