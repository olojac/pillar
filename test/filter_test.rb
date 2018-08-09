require "test_helper"

class FilterTest < ActiveSupport::TestCase
  
  test "with defaults" do
    klass = Class.new {
      include Pillar
      pillar :filter, :filter, on: [:name, :email]
    }
    params = { filter: "test" }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :where)
    assert(query.last_args_called   == ["name ILIKE (:term) && email ILIKE (:term)", term: "%test%"])
  end

  test "with different param name" do
    klass = Class.new {
      include Pillar
      pillar :filter, :search, on: [:name, :email]
    }
    params = { search: "test" }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :where)
    assert(query.last_args_called   == ["name ILIKE (:term) && email ILIKE (:term)", term: "%test%"])
  end

  test "with custom scope" do
    klass = Class.new {
      include Pillar
      pillar :filter, :filter, scope: ->(term) { search("name LIKE (:term)", term: "%#{term}%") }
    }
    params = { filter: "test" }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.last_method_called == :search)
    assert(query.last_args_called   == ["name LIKE (:term)", term: "%test%"])
  end 

end
