require "test_helper"

class QueryTest < ActiveSupport::TestCase

  test "selected opartion should only be queried, paginate" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page
      pillar :filter,   :search, on: [:name, :email]
      pillar :sort,     :name
      pillar :sort,     :email
    }

    params = {}
    query  = klass.pillar.query(Support::MockQuery.new, params, with: [:paginate])

    assert(query.methods_called == [:limit, :offset])
    assert(query.args_called    == [[20], [0]])
  end

  test "selected opartion should only be queried, filter" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page
      pillar :filter,   :search, on: [:name, :email]
      pillar :sort,     :name
      pillar :sort,     :email
    }

    params = { search: "test" }
    query  = klass.pillar.query(Support::MockQuery.new, params, with: [:filter])

    assert(query.methods_called == [:where])
    assert(query.args_called    == [["name ILIKE (:term) && email ILIKE (:term)", { term: "%test%" }]])
  end

  test "selected opartion should only be queried, sort" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page
      pillar :filter,   :search, on: [:name, :email]
      pillar :sort,     :name
      pillar :sort,     :email
    }

    params = { search: "test" }
    query  = klass.pillar.query(Support::MockQuery.new, params, with: [:sort])

    assert(query.methods_called == [:order])
    assert(query.args_called    == [[{ name: :asc }]])
  end

end
