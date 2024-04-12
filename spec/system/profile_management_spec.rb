# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile management', type: :system do
  let!(:user) { create(:user) }
  let(:currency_code) { 'CODE' }

  before do
    create(:invoice_category)
    create(:currency, default: true, code: currency_code)
    create(:profile, user: user)
    login_user(user)
  end

  describe 'Profile update' do
    context 'with valid data' do
      it 'updates the profile successfully' do
        visit profile_path

        fill_profile_form

        click_on 'Save'
        # Assert successful update
        expect(page).to have_content('Profile was successfully updated.')
      end
    end

    context 'with invalid data' do
      it 'displays errors when required fields are blank' do
        visit profile_path
        # Submit form with blank fields
        fill_in 'profile[full_name]', with: ''
        click_on 'Save'
        # Assert error messages for required fields
        expect(page).to have_content('Full name can\'t be blank')
        # Add more assertions for other required fields if necessary
      end
    end

    context 'when user does not have a profile' do
      before { user.profile.destroy }

      it 'creates a new profile' do
        visit profile_path

        expect(user.reload.profile).to be_nil

        fill_profile_form

        # Assert profile is created
        expect { click_on 'Save' }.to change(Profile, :count).by(1)
        expect(page).to have_content('Profile was successfully created')
      end
    end
  end
end

def fill_profile_form
  fill_in 'profile[full_name]', with: 'John Doe'
  select 'Individual', from: 'profile[legal_status]'

  fill_in 'profile[phone_number]', with: '1234567890'
  fill_in 'profile[date_of_birth]', with: '01/01/1990'
  select 'Nigeria', from: 'profile[nationality]'

  fill_in 'profile[business_name]', with: 'John Doe Inc.'
  fill_in 'profile[tax_number]', with: '1234567890'
  fill_in 'profile[vat_id]', with: '1234567890'
  find(:select, 'profile[country]').first(:option, 'Germany').select_option

  select 'English', from: 'profile[language]'
  select currency_code, from: 'profile[currency_id]'

  fill_in 'profile[address_attributes][street_address]', with: '123 Main Street'
  fill_in 'profile[address_attributes][city]', with: 'Lagos'
  fill_in 'profile[address_attributes][state]', with: 'Lagos'
  fill_in 'profile[address_attributes][postal_code]', with: '100001'
  select 'Nigeria', from: 'profile[address_attributes][country]'
end
