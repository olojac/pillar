require "pillar/store"
require "pillar/view_helpers/filter"
require "pillar/view_helpers/sort"
require "pillar/view_helpers/paginate"

require "active_support"
ActiveSupport.on_load(:action_view) {
  include Pillar::ViewHelpers::Filter
  include Pillar::ViewHelpers::Sort
  include Pillar::ViewHelpers::Paginate
}

module Pillar
  def self.included(klass)
    klass.class_variable_set("@@pillar_store", Store.new)
    klass.define_singleton_method("pillar") do |command = nil, param = nil, args = nil|
      case command
      when :sort
        klass.class_variable_get("@@pillar_store").send(:add_sort, param, args)
      when :paginate
        klass.class_variable_get("@@pillar_store").send(:add_paginate, param, args)
      when :filter
        klass.class_variable_get("@@pillar_store").send(:add_filter, param, args)
      else
        klass.class_variable_get("@@pillar_store")
      end
    end
  end
end
