require "pillar/paginate"
require "pillar/sort"
require "pillar/sort_column"
require "pillar/filter"
require "pillar/query"

module Pillar
  class Store

    attr_reader :sort
    attr_reader :paginate
    attr_reader :filter

    def initialize
      @sort     = nil
      @paginate = nil
      @filter   = nil
    end

    def query(input_query, params, with: nil)
      with ||= registered_operations
      Query.new(self, input_query, with, params).perform
    end

    private

      def registered_operations
        operations = []
        operations << :sort     unless @sort.nil?
        operations << :paginate unless @paginate.nil?
        operations << :filter   unless @filter.nil?

        return operations
      end

      def add_sort(param, args)
        @sort ||= Sort.new
        @sort.add(SortColumn.new(param, args))
      end

      def add_paginate(param, args)
        @paginate = Paginate.new(param, args)
      end

      def add_filter(param, args)
        @filter = Filter.new(param, args)
      end

  end
end
