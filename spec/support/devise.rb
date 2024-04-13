# frozen_string_literal: true

require 'devise'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :system

  def login_user(user = nil)
    user ||= user || FactoryBot.create(:user, :confirmed)
    user.confirm
    sign_in(user, scope: :user)
  end

  def logout_user
    sign_out(:user)
  end
end

# before(:each, type: :system) do
#   Warden.test_mode!
# end

# after(:each, type: :system) do
#   Warden.test_reset!
# end
