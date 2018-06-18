require "pillar/paginate"
require "pillar/sort"
require "pillar/filter"
require "pillar/query"

module Pillar
  class Store

    def initialize
      @sort_store     = ActiveSupport::HashWithIndifferentAccess.new
      @paginate_store = nil
      @filter_store   = nil
    end

    def query(input_query)
      Query.new(self, input_query)
    end

    def sort(params)
      param       = params[:sort]
      sort_column = @sort_store[param] || @sort_store.values.first
      direction   = params[:direction] || sort_column.options[:default_direction].to_s
      sort_scope  = sort_column.scope.curry

      return sort_scope.call(direction)
    end

    def paginate(params = nil)
      return @paginate_store if params.nil?
      
      @paginate_store.scope(params)
    end

    def filter(params = nil)
      return @filter_store if params.nil?
      
      @filter_store.scope(params)
    end

    def add_sort(args)
      sort_column = Sort.new(args)
      define_singleton_method(sort_column.param) { @sort_store[sort_column.param] }
      @sort_store[sort_column.param] = sort_column
    end

    def add_paginate(args)
      @paginate_store = Paginate.new(args)
    end

    def add_filter(args)
      @filter_store = Filter.new(args)
    end

    def to_h
      @sort_store
    end

    def to_a
      @sort_store.values
    end

  end
end
