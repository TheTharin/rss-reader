# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'webmock/rspec'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.tty = true
  config.mock_with :rspec

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ApplicationHelper

  config.include Shoulda::Matchers::ActiveModel
  config.include Shoulda::Matchers::ActiveRecord

  config.infer_base_class_for_anonymous_controllers = true

  config.order = 'random'

  config.filter_run :focus
  config.filter_run_excluding :checking
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
