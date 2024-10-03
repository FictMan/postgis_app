# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end

if Rails.env.test?
  require 'simplecov'
  require 'database_cleaner'
  SimpleCov.start 'rails' do
    add_filter 'app/mailers'
    add_filter 'app/channels'
    add_filter 'app/models'
    add_filter 'app/controllers/application_controller.rb'
    add_filter 'app/jobs/application_job.rb'

    minimum_coverage 90
  end
end
