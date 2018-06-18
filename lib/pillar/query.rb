module Pillar
  class Query

    def initialize(store, query)
      @store = store
      @query = query
    end

    def with(*args)
      params     = args.pop
      operations = args & POSSIBLE_OPERATIONS
      operations.each do |operation|
        send(operation, params)
      end

      return @query
    end

    def sort(params)
      @query = @store.sort(params).call(@query)

      return @query
    end

    def paginate(params)
      raise ArgumentError, "paginate is not specified on this model" if @store.paginate.nil? 
      @query = @store.paginate(params).call(@query)

      return @query
    end

    def filter(params)
      raise ArgumentError, "filter is not specified on this model" if @store.filter.nil?
      return @query if params[@store.filter.param].blank?
      @query = @store.filter(params).call(@query)

      return @query
    end

    POSSIBLE_OPERATIONS = [:sort, :paginate, :filter].freeze

  end
end
