module Support
  class MockQuery < BasicObject

    CATCH = [:order, :custom].freeze

    attr_reader :args_called
    attr_reader :method_called

    def initialize
      @args_called   = nil
      @method_called = nil
    end

    def method_missing(name, *args, &block)
      super unless CATCH.include? name

      @args_called   = args
      @method_called = name

      return self
    end

    def respond_to_missing?(name, include_private = false)
      CATCH.include?(name) || super
    end

  end
end
