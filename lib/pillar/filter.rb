module Pillar
  class Filter

    DEFAULT_SCOPE = ->(fields, term) { where(fields.map { |f| "#{f} ILIKE (:term)" }.join(" && "), term: "%#{term}%") }

    attr_reader :param

    def initialize(param = nil, args = {})
      args ||= {}
      raise ArgumentError, "parameter 'on:' or 'scope:' is required for pillar :filter" if args[:scope].nil? && args[:on].nil?

      @param  = param
      @fields = args&.delete(:on)
      @scope  = args&.delete(:scope) || DEFAULT_SCOPE
    end

    def scope(query, params)
      # note: curry dosn't work with instance_exec
      case @scope.arity
      when 2
        query.instance_exec(@fields, params[@param], &@scope)
      else
        query.instance_exec(params[@param], &@scope)
      end
    end

  end
end
