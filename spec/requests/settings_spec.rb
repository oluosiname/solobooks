# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Settings', type: :request do
  let(:user) { create(:user, :with_profile) }

  before do
    user.update(confirmed_at: Time.zone.now)
    login_user(user)
  end

  describe 'POST /settings' do
    it 'creates a new setting' do
      post settings_path, params: { setting: { language: 'en', currency_id: user.profile.invoice_currency_id } }

      expect(response.body).to include('Setting was successfully updated.')
    end
  end

  describe 'PATCH /settings' do
    let(:setting) { create(:setting, profile: user.profile) }

    it 'updates the setting' do
      patch setting_path(setting),
        params: { setting: { language: 'en', currency_id: user.profile.invoice_currency_id } }

      expect(response.body).to include('Setting was successfully updated')
    end
  end
end
