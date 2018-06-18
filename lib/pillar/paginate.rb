module Pillar
  class Paginate

    attr_reader :options

    DEFAULT_SCOPE   = ->(per_page, page, query) { query.limit(per_page).offset((page - 1) * per_page) }
    DEFAULT_OPTIONS = { per_page: 20 }.freeze

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
        num = (params[@param] || 1).to_i
        num = 1 if num < 1

        return num
      end

  end
end
