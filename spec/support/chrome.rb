# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV['SHOW_BROWSER'] == 'true'
      driven_by :selenium_chrome
    else
      driven_by :rack_test
    end
  end

  config.before(:each, :js, type: :system) do
    driven_by :selenium_chrome_headless # selenium when we need javascript
    # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
  config.before(:each, :browser, :js, type: :system) do
    driven_by :selenium_chrome # selenium when we need javascript
    # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
