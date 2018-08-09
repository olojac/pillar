module Pillar
  class Query

    def initialize(store, query, operations, params)
      @store      = store
      @query      = query
      @operations = operations & POSSIBLE_OPERATIONS
      @params     = params
    end

    def perform
      @operations.each do |operation|
        send(operation, @params)
      end

      return @query
    end

    def sort(params)
      raise ArgumentError, "sort is not specified on this model" if @store.sort.nil?
    
      @query = @store.sort.scope(@query, params)
    end

    def paginate(params)
      raise ArgumentError, "paginate is not specified on this model" if @store.paginate.nil? 
      
      @query = @store.paginate.scope(@query, params)
    end

    def filter(params)
      raise ArgumentError, "filter is not specified on this model" if @store.filter.nil?
      return @query if params[@store.filter.param].blank?

      @query = @store.filter.scope(@query, params)
    end

    POSSIBLE_OPERATIONS = [:sort, :paginate, :filter].freeze

  end
end
