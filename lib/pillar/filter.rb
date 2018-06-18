module Pillar
  class Filter

    attr_reader :param

    def initialize(args = {})
      raise ArgumentError, "parameter 'scope:' is required for pillar :filter" if args[:scope].nil?

      @param   = args.delete(:param) || :filter
      @scope   = args.delete(:scope)
    end

    def scope(params)
      @scope.curry.call(params[@param])
    end

  end
end
