require "pillar/store"
require "pillar/view_helpers"

require "active_support"
ActiveSupport.on_load(:action_view) { include Pillar::ViewHelpers }

module Pillar
  def self.included(klass)
    klass.class_variable_set("@@pillar_store", Store.new)
    klass.define_singleton_method("pillar") do |command = nil, args = nil|
      case command
      when :sort
        klass.class_variable_get("@@pillar_store").add_sort(args)
      when :paginate
        klass.class_variable_get("@@pillar_store").set_paginate(args)
      else
        klass.class_variable_get("@@pillar_store")
      end
    end
  end
end
