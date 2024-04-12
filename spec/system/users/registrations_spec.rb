# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :system do
  it 'allows users to register' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content("A message with a confirmation link has been sent to your email address. \
Please follow the link to activate your account.")
    expect(page).to have_current_path('/en/instructions_sent')
  end

  context 'when password is too short' do
    it 'displays error message' do
      visit new_user_registration_path

      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'pass'
      fill_in 'Password confirmation', with: 'pass'
      click_on 'Sign up'

      expect(page).to have_content('Password is too short (minimum is 6 characters)')
    end
  end

  it 'displays error messages for invalid registration' do
    visit new_user_registration_path

    fill_in 'Email', with: 'invalid_email@'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content('Email is invalid')
  end

  it 'displays error message when password confirmation does not match' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'different_password'
    click_on 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  context 'when email is already taken' do
    before { create(:user, email: 'existing@example.com') }

    it 'displays error message when email is already taken' do
      visit new_user_registration_path

      fill_in 'Email', with: 'existing@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_on 'Sign up'

      expect(page).to have_content('Email has already been taken')
    end
  end
end
