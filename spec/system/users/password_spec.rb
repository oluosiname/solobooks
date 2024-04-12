# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Password Management', type: :system do
  context 'requesting password reset' do
    let!(:user) { create(:user, :confirmed, email: 'test@example.com', password: 'password') }

    it 'requests password change', :chrome, :js do
      visit new_user_session_path

      click_on 'Forgot your password?'

      fill_in 'user[email]', with: user.email
      click_on 'Reset password'

      expect(page).to have_content('If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes')
    end
  end

  context 'updating password' do
    let!(:user) { create(:user, :confirmed, email: 'test@example.com', password: 'password') }

    it 'updates password' do
      visit edit_user_password_path(reset_password_token: user.send_reset_password_instructions)

      fill_in 'user[password]', with: 'new-password'
      fill_in 'user[password_confirmation]', with: 'new-password'
      click_on 'Change password'

      expect(page).to have_content('Your password has been changed successfully. You are now signed in.')
      expect(page).to have_current_path(root_path)
    end

    context 'with invalid token' do
      it 'does not update password' do
        visit edit_user_password_path(reset_password_token: 'invalid-token')

        fill_in 'user[password]', with: 'new-password'
        fill_in 'user[password_confirmation]', with: 'new-password'

        click_on 'Change password'

        expect(page).to have_current_path(user_password_path)
        expect(page).to have_content('1 error prohibited this user from being saved')
      end
    end
  end
end
