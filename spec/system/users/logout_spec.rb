# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logout', type: :system do
  let!(:user) { create(:user) }

  before do
    login_user(user)
  end

  describe 'Logging out' do
    it 'logs out user' do
      visit root_path

      click_on 'Logout'
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('Signed out successfully')
    end
  end
end
