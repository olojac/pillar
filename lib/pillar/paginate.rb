module Pillar
  class Paginate

    attr_reader :options

    DEFAULT_SCOPE   = ->(per_page, page, query){ query.limit(per_page).offset(page * per_page) }
    DEFAULT_OPTIONS = {
      per_page: 20,
    }

    def initialize(args = {})
      @param   = args.delete(:param) || :page
      @scope   = args.delete(:scope) || DEFAULT_SCOPE
      @options = DEFAULT_OPTIONS.merge(args)
    end

    def scope(params)
      @scope.curry.call(@options[:per_page], page(params))
    end

    private

      def page(params)
        num = (params[@param] || 0).to_i
        num = 0 if num < 0

        return num
      end

  end
end