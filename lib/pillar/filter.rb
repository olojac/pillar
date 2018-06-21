module Pillar
  class Filter

    DEFAULT_SCOPE = ->(fields, term, query) { query.where(fields.map { |f| "#{f} ILIKE (:term)" }.join(" && "), term: "%#{term}%") }

    attr_reader :param

    def initialize(args = {})
      raise ArgumentError, "parameter 'on:' or 'scope:' is required for pillar :filter" if args[:scope].nil? && args[:on].nil?

      @param  = args&.delete(:param) || :filter
      @fields = args&.delete(:on)
      @scope  = args&.delete(:scope) || DEFAULT_SCOPE.curry.call(@fields)
    end

    def scope(params)
      @scope.curry.call(params[@param])
    end

  end
end
