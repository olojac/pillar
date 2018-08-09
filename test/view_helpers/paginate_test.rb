require "test_helper"
require "action_view/test_case"

module ViewHelpers
  class PaginateTest < ActionView::TestCase
    include Pillar::ViewHelpers::Paginate

    test "helpers basic function" do
      klass = Class.new {
        include Pillar
        pillar :paginate, :page
      }
      params[:page] = "3"
      
      stub :url_for, "test" do
        assert_dom_equal(
          '<ul class="pagination">' \
            '<li class="page-item"><a class="page-link" href="test">1</a></li>' \
            '<li class="page-item"><a class="page-link" href="test">2</a></li>' \
            '<li class="page-item active"><a class="page-link" href="test">3</a></li>' \
            '<li class="page-item"><a class="page-link" href="test">4</a></li>' \
            '<li class="page-item"><a class="page-link" href="test">5</a></li>' \
            '<li class="page-item"><a class="page-link" href="test">6</a></li>' \
            '<li class="page-item"><a class="page-link" href="test">7</a></li>' \
            '<li class="page-item disabled"><span class="page-link">...</span></li>' \
            '<li class="page-item"><a class="page-link" href="test">50</a>' \
          '</ul>',
          pillar_paginate(klass.pillar, 1000)
        )
      end
    end

  end
end
