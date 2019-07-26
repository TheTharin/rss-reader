# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'webmock/rspec'
require 'capybara/rails'
require 'selenium/webdriver'

require_relative 'ui_lib/page_objects'

RSpec.configure do |config|
  config.tty = true
  config.mock_with :rspec

  config.include FactoryBot::Syntax::Methods
  config.include ApplicationHelper

  config.after(:suite) do
    FileUtils.rm_rf Rails.root.join('spec/support/uploads')
    FileUtils.rm_rf Rails.root.join('tmp/capybara')
  end

  config.before(:all) do
    WebMock.disable_net_connect!(allow_localhost: true,
                                 allow: 'chromedriver.storage.googleapis.com')
  end

  config.filter_run :focus
  config.filter_run_excluding :checking
  config.run_all_when_everything_filtered = true

  config.after :each do # после каждого прогона тестов очищаем сессию и куки в ней
    Capybara.current_session.cleanup!
  end
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.register_driver :chrome do |app|
  capabilities =
    Selenium::WebDriver::Remote::Capabilities
    .chrome(chromeOptions: { args: ['--window-size=1920,1080', '--headless'] })

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities)
end

Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.javascript_driver = :chrome
end
