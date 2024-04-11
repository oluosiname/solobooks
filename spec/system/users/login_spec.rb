# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  context 'with valid credentials' do
    before { create(:user, :confirmed, email: 'test@example.com', password: 'password') }

    it 'allows users to Login' do
      visit new_user_session_path

      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password'
      click_on 'Login'

      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_current_path(root_path)
    end
  end

  context 'with invalid credentials' do
    it 'displays error message when email is incorrect' do
      visit new_user_session_path

      fill_in 'Email', with: 'nonexistent@example.com'
      fill_in 'Password', with: 'password'
      click_on 'Login'

      expect(page).to have_content('Invalid Email or password.')
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'displays error message when password is incorrect' do
      create(:user, email: 'test@example.com', password: 'password')

      visit new_user_session_path

      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'incorrect_password'
      click_on 'Login'

      expect(page).to have_content('Invalid Email or password.')
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'displays error message when both email and password are incorrect' do
      visit new_user_session_path

      fill_in 'Email', with: 'nonexistent@example.com'
      fill_in 'Password', with: 'incorrect_password'
      click_on 'Login'

      expect(page).to have_content('Invalid Email or password.')
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
