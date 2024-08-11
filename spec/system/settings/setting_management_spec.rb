# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Settin g Management', type: :system do
  let!(:user) { create(:user, :with_profile) }
  let(:currency_code) { 'CODE' }
  let!(:currency) { create(:currency, default: true, code: currency_code) }

  before do
    login_user(user)
  end

  context 'with valid data' do
    it 'sets language and currency', :js do
      visit '/settings'

      select 'English', from: 'setting[language]'
      select currency_code, from: 'setting[currency_id]'

      within '#setting-card' do
        #  expect { click_on 'Save' }.to change(Setting, :count).by(1)
        click_on 'Save'
      end

      expect(page).to have_content('Setting was successfully created')
      expect(user.reload.setting.language).to eq('en')
      expect(user.reload.setting.currency).to eq(currency)
    end
  end
end
