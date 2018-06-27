require "test_helper"

class SortTest < ActiveSupport::TestCase
  
  test "with default params" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, {})

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :asc }])
  end

  test "with a direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, direction: "desc")

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :desc }])
  end

  test "with a default direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name, default_direction: :desc
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, {})

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :desc }])
  end

  test "with a custom scope" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name, scope: ->(direction, query) { query.custom("name #{direction}") }
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:sort, {})

    assert(query.last_method_called == :custom)
    assert(query.last_args_called   == ["name asc"])
  end

  test "with missing param" do
    assert_raises ArgumentError do 
      Class.new {
        include Pillar
        pillar :sort
      }
    end
  end

  test "helpers with default direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name
    }
    column = klass.pillar.sort[:name]

    # selected
    params = { sort: "name" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == true)

    # selected with direction
    params = { sort: "name", direction: "desc" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == true)

    # not selected
    params = { sort: "other" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == false)

    # not selected with direction
    params = { sort: "other", direction: "desc" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == false)
  end

  test "helpers with reverse default direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, param: :name, default_direction: :desc
    }
    column = klass.pillar.sort[:name]

    # selected
    params = { sort: "name" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == true)

    # selected with direction
    params = { sort: "name", direction: "asc" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == true)

    # not selected
    params = { sort: "other" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == false)

    # not selected with direction
    params = { sort: "other", direction: "asc" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == false)
  end

end
