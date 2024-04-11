# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registration', type: :system do
  context 'with valid credentials' do
    it 'confirms user' do
      visit new_user_registration_path

      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Sign up'

      expect(page).to have_current_path(confirmation_instructions_sent_path)
      expect(page).to have_content('A confirmation email has been sent to your inbox. Please check your email and follow the instructions to complete the process.')
    end
  end
end
