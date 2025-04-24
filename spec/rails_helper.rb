require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'webdrivers'

# Проверка миграций
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.define_derived_metadata(file_path: %r{/spec/controllers/}) { |meta| meta[:type] = :controller }
  config.define_derived_metadata(file_path: %r{/spec/requests/})   { |meta| meta[:type] = :request }
  config.define_derived_metadata(file_path: %r{/spec/features/})   { |meta| meta[:type] = :feature }
  config.define_derived_metadata(file_path: %r{/spec/system/})     { |meta| meta[:type] = :system }

  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Настройка драйверов с автоматическим определением окружения
chrome_options = lambda do |options|
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1400,1400')

  # Для CI окружения (например, GitHub Actions)
  if ENV['CI']
    options.add_argument('--headless')
    options.add_argument('--disable-extensions')
  end

  # Для macOS
  if RUBY_PLATFORM.include?('darwin')
    options.binary = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  end
end

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.call(options)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  chrome_options.call(options)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# Настройки по умолчанию
Capybara.javascript_driver = ENV['HEADLESS'] == 'false' ? :selenium_chrome : :selenium_chrome_headless
Capybara.default_driver = :rack_test
Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = 5

# Явная установка версии chromedriver для совместимости
Webdrivers::Chromedriver.required_version = '135.0.7049.97' # Укажите актуальную версию