module Pillar
  class SortColumn

    attr_reader :param
    attr_reader :default_direction

    DEFAULT_SCOPE = ->(param, direction) { order(param.to_sym => direction.to_sym) }

    def initialize(param, args)
      raise ArgumentError, "parameter name is required for pillar :sort" if param.nil?

      @param             = param
      @default_direction = args&.delete(:default_direction) || :asc
      @scope             = args&.delete(:scope) || DEFAULT_SCOPE
    end
    
    def scope(query, params)
      # note: curry dosn't work with instance_exec
      case @scope.arity
      when 2
        query.instance_exec(@param, direction(params), &@scope)
      else
        query.instance_exec(direction(params), &@scope)
      end
    end

    def direction(params)
      direction   = params[@param] if selected?(params)
      direction ||= default_direction.to_s

      return direction
    end

    def next_direction(params)
      return direction(params) unless selected?(params)

      case direction(params)
      when "asc"
        "desc"
      when "desc"
        "asc"
      end
    end

    def selected?(params)
      params&.key?(@param)
    end

  end
end
