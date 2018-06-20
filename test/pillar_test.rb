require "test_helper"
require "active_model"

class PillarTest < ActiveSupport::TestCase
  
  test "has a version" do
    refute_nil ::Pillar::VERSION
  end

end
