module Pillar
  class Sort

    attr_reader :param
    attr_reader :default_direction

    DEFAULT_SCOPE = ->(param, direction, query) { query.order(param.to_sym => direction.to_sym) }

    def initialize(args)
      raise ArgumentError, "parameter 'param:' is required for pillar :sort" if args&.fetch(:param).nil?

      @param             = args&.delete(:param)
      @scope             = args&.delete(:scope) || DEFAULT_SCOPE.curry.call(@param)
      @default_direction = args&.delete(:default_direction) || :asc
    end

    def scope(params)
      @scope.curry.call(params[:direction] || default_direction.to_s)
    end

    def direction(params)
      direction   = params[:direction] if selected?(params)
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
      params[:sort] == param.to_s
    end

  end
end
