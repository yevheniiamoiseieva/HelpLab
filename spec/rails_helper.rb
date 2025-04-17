require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'webdrivers' # Добавляем этот require

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

  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
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

# Настройка драйвера для Chrome
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[no-sandbox disable-dev-shm-usage disable-gpu window-size=1400,1400]
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# Для headless-режима (рекомендуется для CI)
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox disable-dev-shm-usage disable-gpu window-size=1400,1400]
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# Используем headless по умолчанию
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_driver = :rack_test # Для не-JS тестов
