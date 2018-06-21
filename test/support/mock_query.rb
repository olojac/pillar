module Support
  class MockQuery < BasicObject

    CATCH = [:order, :custom, :limit, :offset, :stop_after, :move, :where, :search].freeze

    attr_reader :args_called
    attr_reader :methods_called

    def initialize
      @args_called    = []
      @methods_called = []
    end

    def last_args_called
      @args_called.last
    end

    def last_method_called
      @methods_called.last
    end

    def method_missing(name, *args, &block)
      super unless CATCH.include? name

      @args_called    << args
      @methods_called << name

      return self
    end

    def respond_to_missing?(name, include_private = false)
      CATCH.include?(name) || super
    end

  end
end
