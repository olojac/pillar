require "bundler/setup"
require "time_window"
require "pry"

Dir[File.expand_path('../support/**/*.rb',  __FILE__)].each {|f| require f}

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
