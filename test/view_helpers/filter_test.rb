require "test_helper"
require "action_view/test_case"

module ViewHelpers
  class FilterTest < ActionView::TestCase
    include Pillar::ViewHelpers::Filter

    test "helpers basic function" do
      klass = Class.new {
        include Pillar
        pillar :filter, :filter, on: [:name, :email]
      }
      
      stub :url_for, "test" do
        assert_dom_equal(
          '<form class="filter" action="test" accept-charset="UTF-8" method="get">' \
            '<input name="utf8" type="hidden" value="&#x2713;" />' \
            '<div class="input-group">' \
              '<input type="text" name="filter" id="filter" class="form-control" />' \
              '<div class="input-group-append">' \
                '<a class="btn btn-outline-secondary" href="test">Clear</a>' \
                '<button name="" type="submit" class="btn btn-primary">Filter</button>' \
              '</div>' \
            '</div>' \
          '</form>',
          pillar_filter(klass.pillar)
        )
      end
    end

  end
end
