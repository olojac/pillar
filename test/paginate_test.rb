require "test_helper"

class PaginateTest < ActiveSupport::TestCase
  
  test "with default params" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page
    }
    params = {}
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.methods_called == [:limit, :offset])
    assert(query.args_called    == [[20], [0]])
  end

  test "with default params on a different page" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page
    }
    params = { page: 4 }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.methods_called == [:limit, :offset])
    assert(query.args_called    == [[20], [60]]) # (page - 1) * 20
  end

  test "with different param name" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :sida
    }
    params = { sida: 4 }
    query = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.methods_called == [:limit, :offset])
    assert(query.args_called    == [[20], [60]])
  end

  test "with a diffrent per_page" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, per_page: 10
    }
    params = { page: 11 }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.methods_called == [:limit, :offset])
    assert(query.args_called    == [[10], [100]])
  end

  test "with a custom scope" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, scope: ->(per_page, page) { stop_after(per_page).move((page - 1) * per_page) }
    }
    params = { page: 11 }
    query  = klass.pillar.query(Support::MockQuery.new, params)

    assert(query.methods_called == [:stop_after, :move])
    assert(query.args_called    == [[20], [200]])
  end

  test "#pages with many pages" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, per_page: 10
    }
    pages = klass.pillar.paginate.pages(30, 1000)

    assert(pages == [1, :sep, 26, 27, 28, 29, 30, 31, 32, 33, 34, :sep, 100])
  end

  test "#pages will not show" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, per_page: 10
    }
    pages = klass.pillar.paginate.pages(1, 3)

    assert(pages == [1])
  end

  test "#pages with few pages" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, per_page: 10
    }
    pages = klass.pillar.paginate.pages(2, 30)
    
    assert(pages == [1, 2, 3])
  end

  test "#pages at end of list" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, per_page: 10
    }
    pages = klass.pillar.paginate.pages(100, 1000)
    
    assert(pages == [1, :sep, 96, 97, 98, 99, 100])
  end

  test "#pages at begining of list" do
    klass = Class.new {
      include Pillar
      pillar :paginate, :page, per_page: 10
    }
    pages = klass.pillar.paginate.pages(1, 1000)
    
    assert(pages == [1, 2, 3, 4, 5, :sep, 100])
  end

end
