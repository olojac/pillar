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
      @query = @store.paginate(params).call(@query)

      return @query
    end

    private

      POSSIBLE_OPERATIONS = [:sort, :paginate]

  end
end
