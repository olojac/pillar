require "test_helper"

class FilterTest < ActiveSupport::TestCase
  
  test "with defaults" do
    klass = Class.new {
      include Pillar
      pillar :filter, on: [:name, :email]
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:filter, filter: "test")

    assert(query.last_method_called == :where)
    assert(query.last_args_called   == ["name ILIKE (:term) && email ILIKE (:term)", term: "%test%"])
  end

  test "with different param name" do
    klass = Class.new {
      include Pillar
      pillar :filter, param: :search, on: [:name, :email]
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:filter, search: "test")

    assert(query.last_method_called == :where)
    assert(query.last_args_called   == ["name ILIKE (:term) && email ILIKE (:term)", term: "%test%"])
  end

  test "with custom scope" do
    klass = Class.new {
      include Pillar
      pillar :filter, scope: ->(term, query) { query.search("name LIKE (:term)", term: "%#{term}%") }
    }
    query = klass.pillar.query(Support::MockQuery.new).with(:filter, filter: "test")

    assert(query.last_method_called == :search)
    assert(query.last_args_called   == ["name LIKE (:term)", term: "%test%"])
  end 

end
