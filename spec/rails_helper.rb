require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'

# Проверка миграций
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Подключение FactoryBot методов
  config.include FactoryBot::Syntax::Methods

  # Подключение Devise helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature

  # Автоматическое определение типа теста по пути
  config.define_derived_metadata(file_path: %r{/spec/controllers/}) { |meta| meta[:type] = :controller }
  config.define_derived_metadata(file_path: %r{/spec/requests/})   { |meta| meta[:type] = :request }
  config.define_derived_metadata(file_path: %r{/spec/features/})   { |meta| meta[:type] = :feature }
  config.define_derived_metadata(file_path: %r{/spec/system/})     { |meta| meta[:type] = :system }

  # Настройки fixtures и транзакций
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

# Настройка Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_driver = :rack_test