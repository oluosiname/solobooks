# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VatStatus management', type: :system do
  let(:user) { create(:user) }

  before do
    create(:vat_status, user:)
    login_user(user)
  end

  describe 'Updating VAT Status' do
    before do
      visit vat_status_path
    end

    context 'when submitting the form with valid inputs' do
      it 'updates the VAT status successfully' do
        choose 'vat_registered_true'
        select 'Quarterly', from: 'vat_status_declaration_period'
        fill_in 'vat_status_vat_number', with: 'DE123456789'
        fill_in 'vat_status_starts_on', with: Time.zone.today
        check 'vat_status_kleinunternehmer'
        fill_in 'vat_status_tax_exempt_reason', with: 'Exempt according to tax law §4'

        click_on 'Save'

        expect(page).to have_content I18n.t('record.update.success', resource: VatStatus.model_name.human)
      end
    end

    context 'when submitting the form with invalid inputs' do
      it 'displays error messages', :js do
        fill_in 'vat_status_vat_number', with: ''
        click_on 'Save'

        expect(page).to have_content("VAT number can't be blank")
        expect(page).to have_css('#vat_status_errors')
      end
    end

    context 'when VAT is not registered' do
      before do
        choose 'vat_registered_false'
        click_on 'Save'
      end

      it 'does not require VAT number' do
        expect(page).to have_no_content("Vat number can't be blank")
      end

      it 'requires a tax exempt reason' do
        expect(page).to have_content("Tax exempt reason can't be blank")
      end
    end
  end
end
