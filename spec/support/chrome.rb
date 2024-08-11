# frozen_string_literal: true

Capybara.register_driver :selenium_chrome_headless do |app|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless')
    opts.add_argument('--disable-gpu') if Gem.win_platform?
    opts.add_argument('--disable-site-isolation-trials')
    # opts.add_argument('--remote-debugging-port=9222')
    opts.add_argument('--window-size=1400,1400')
  end
  ENV.fetch('GOOGLE_CHROME_SHIM', nil)

  Capybara::Selenium::Driver.new(app, **{ browser: :chrome, options_key => browser_options })
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    if ENV['SHOW_BROWSER'] == 'true'
      driven_by :selenium_chrome
    else
      driven_by :rack_test
    end
  end

  config.before(:each, :js, type: :system) do
    if ENV['SHOW_BROWSER'] == 'true'
      driven_by :selenium_chrome
    else
      driven_by :selenium_chrome_headless # selenium when we need javascript
    end

    # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
