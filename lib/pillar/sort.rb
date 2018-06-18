module Pillar
  class Sort

    attr_reader :param
    attr_reader :scope
    attr_reader :options

    DEFAULT_SCOPE   = ->(param, direction, query) { query.order(param.to_sym => direction.to_sym) }
    DEFAULT_OPTIONS = {
      default_direction: :asc,
    }

    def initialize(args)
      raise ArgumentError, "parameter 'param:' is required for pillar :sort" if args[:param].nil?

      @param   = args.delete(:param)
      @scope   = args.delete(:scope) || DEFAULT_SCOPE.curry.call(@param)
      @options = DEFAULT_OPTIONS.merge(args)
    end

  end
end
