# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logout', type: :system do
  let!(:user) { create(:user) }

  before do
    login_user(user)
  end

  describe 'Logging out' do
    context 'when logging out in side menu' do
      it 'logs out user' do
        visit root_path

        within('.menu') do
          click_on 'Logout'
        end
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content('Signed out successfully')
      end
    end

    context 'when logging out in header' do
      # TODO: Fix this test ensure dropdown is working properly
      it 'logs out user' do
        visit root_path

        within('header') do
          click_on 'Logout'
        end
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content('Signed out successfully')
      end
    end
  end
end
