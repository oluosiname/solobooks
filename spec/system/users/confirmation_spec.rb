
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Confirmation', type: :system do
  context 'with valid credentials' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    it 'confirms user' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token)

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Your email address has been successfully confirmed')
    end
  end
end
