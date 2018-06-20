require "test_helper"

class SortTest < ActiveSupport::TestCase
  
  test "with default params" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, {})

    assert(query.method_called == :order)
    assert(query.args_called   == [{ name: :asc }])
  end

  test "with a direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, direction: "desc")

    assert(query.method_called == :order)
    assert(query.args_called   == [{ name: :desc }])
  end

  test "with a default direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name, default_direction: :desc
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, {})

    assert(query.method_called == :order)
    assert(query.args_called   == [{ name: :desc }])
  end

  test "with a custom scope" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name, scope: ->(direction, query) { query.custom("name #{direction}") }
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, {})

    assert(query.method_called == :custom)
    assert(query.args_called   == ["name asc"])
  end

  test "with missing param" do
    assert_raises ArgumentError do 
      Class.new {
        include Pillar
        pillar :sort
      }
    end
  end

end
