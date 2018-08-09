require "test_helper"

class SortTest < ActiveSupport::TestCase
  
  test "with default params" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name
    }
    params = {}
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :asc }])
  end

  test "with default multiple params" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name
      pillar :sort, :value
    }
    params = {}
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :asc }])
  end

  test "with multiple params" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name
      pillar :sort, :value
    }
    params = { value: "asc" }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ value: :asc }])
  end

  test "with a direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name
    }
    params = { name: "desc" }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :desc }])
  end

  test "with a default direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name, default_direction: :desc
    }
    params = {}
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :order)
    assert(query.last_args_called   == [{ name: :desc }])
  end

  test "with a custom scope" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name, scope: ->(direction) { custom("name #{direction}") }
    }
    params = {}
    query  = klass.pillar.query(Support::MockQuery.new, params)

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
      pillar :sort, :name
    }
    column = klass.pillar.sort.columns[:name]

    # selected
    params = { name: "asc" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == true)

    # selected with direction
    params = { name: "desc" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == true)

    # not selected
    params = { other: "asc" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == false)

    # not selected with direction
    params = { other: "desc" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == false)
  end

  test "helpers with reverse default direction" do
    klass = Class.new {
      include Pillar
      pillar :sort, :name, default_direction: :desc
    }
    column = klass.pillar.sort.columns[:name]

    # selected
    params = { name: "desc" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "asc")
    assert(column.selected?(params)      == true)

    # selected with direction
    params = { name: "asc" }
    assert(column.direction(params)      == "asc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == true)

    # not selected
    params = { other: "desc" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == false)

    # not selected with direction
    params = { other: "asc" }
    assert(column.direction(params)      == "desc")
    assert(column.next_direction(params) == "desc")
    assert(column.selected?(params)      == false)
  end

end
