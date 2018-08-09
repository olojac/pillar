require "active_support/core_ext/hash/indifferent_access"

module Pillar
  class Sort

    attr_reader :columns

    def initialize
      @columns = ActiveSupport::HashWithIndifferentAccess.new
    end

    def add(column)
      @columns[column.param] = column
    end

    def registered_keys
      @columns.keys.map(&:to_s)
    end

    def param(name, direction)
      sort_params       = registered_keys.map { |key| [key, nil] }.to_h
      sort_params[name] = direction

      return sort_params
    end

    def scope(query, params)
      param_keys = params&.keys&.map(&:to_s) 
      sort_keys  = param_keys & registered_keys # filter out non sort keys
      selected   = sort_keys&.first || registered_keys.first.to_sym

      @columns[selected].scope(query, params)
    end

  end
end
