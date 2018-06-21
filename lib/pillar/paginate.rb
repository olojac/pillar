module Pillar
  class Paginate

    attr_reader :options

    DEFAULT_SCOPE   = ->(per_page, page, query) { query.limit(per_page).offset((page - 1) * per_page) }
    DEFAULT_OPTIONS = { per_page: 20 }.freeze

    def initialize(args = {})
      args   ||= {}
      @param   = args&.delete(:param) || :page
      @scope   = args&.delete(:scope) || DEFAULT_SCOPE
      @options = DEFAULT_OPTIONS.merge(args)
    end

    def scope(params)
      @scope.curry.call(@options[:per_page], page(params))
    end

    def pages(current, item_count)
      max            = pages_count(item_count)
      naive_array    = [1] + ((current - 4)..(current + 4)).to_a + [max]
      pages          = naive_array.select { |n| n.positive? && n <= max }.uniq.sort
      pages_with_sep = pages.slice_when { |i, j| i + 1 != j }.flat_map { |group| group + [:sep] }[0..-2]

      return pages_with_sep
    end

    def page(params)
      num = (params[@param] || 1).to_i
      num = 1 if num < 1

      return num
    end

    private

      def pages_count(item_count)
        return Float::INFINITY if item_count.nil?
        max  = item_count / @options[:per_page] - 1
        rest = item_count % @options[:per_page]
        max += 1 if rest.positive?
        max += 1 # page starts at 1

        return max
      end

  end
end
