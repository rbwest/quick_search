ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __FILE__)
ActiveRecord::Migration.maintain_test_schema!
require 'rails/test_help'
require 'capybara/rails'
require 'vcr'
require 'headless'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

headless = Headless.new
headless.start


# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  extend VcrTest
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  Capybara.run_server = true
  Capybara.server_port = 7000
  Capybara.app_host = "http://localhost:#{Capybara.server_port}"
  Capybara.javascript_driver = :webkit
  Capybara.default_max_wait_time = 8

end

VCR.configure do |c|
  # c.ignore_localhost = true
  c.hook_into :webmock
  c.cassette_library_dir = 'test/vcr_cassettes'
end
