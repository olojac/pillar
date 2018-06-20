$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pillar"

# libs
require "active_support"
require "pry"

# test support
Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }

# minitest additonals
require "minitest/reporters"
reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
require "minitest/autorun"
