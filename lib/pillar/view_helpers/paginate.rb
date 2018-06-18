module Pillar
  module ViewHelpers
    module Paginate

      def pillar_paginate_simple(store, total = nil)
        current   = (params[:page] || 1).to_i
        max       = max_page(store.options[:per_page], total)
        prev_link = pillar_paginate_link(current - 1) if current.posivite?
        next_link = pillar_paginate_link(current + 1) if current < max

        content_tag(:ul, class: "pagination") {
          concat pillar_paginate_item(prev_link || pillar_paginate_prev_label)
          concat pillar_paginate_item(next_link || pillar_paginate_next_label)
        }
      end

      def pillar_paginate(store, total)
        current = (params[:page] || 1).to_i
        max     = max_page(store.options[:per_page], total)
        pages   = paginate_array(current, max)

        content_tag(:ul, class: "pagination") {
          pages.each { |page|
            concat pillar_paginate_item(page, current)
          }
        }
      end

      def pillar_paginate_item(page, current = nil)
        return content_tag(:li, pillar_pageinate_seperatior, class: "page-item disabled") if page == :sep
        return content_tag(:li, pillar_paginate_link(page),  class: "page-item active")   if page == current
        return content_tag(:li, pillar_paginate_link(page),  class: "page-item")
      end

      def pillar_paginate_link(page)
        link_to(page, current_path_with_params(page: page), class: "page-link")
      end

      def pillar_pageinate_seperatior
        content_tag(:span, "...", class: "page-link")
      end

      def pillar_paginate_next_label
        "Next ⯈"
      end

      def pillar_paginate_prev_label
        "⯇ Prev"
      end

      private

        def paginate_array(current, max)
          naive_array            = [1] + ((current - 4)..(current + 4)).to_a + [max]
          pages                  = naive_array.select { |n| n.positive? && n <= max }.uniq.sort
          pages_with_seperations = pages.slice_when { |i, j| i + 1 != j }.flat_map { |group| group + [:sep] }[0..-2]

          return pages_with_seperations
        end

        def max_page(per_page, total)
          return Float::INFINITY if total.nil?
          max  = total / per_page - 1
          rest = total % per_page
          max += 1 if rest.positive?

          return max
        end

        def current_path_with_params(new_param = {})
          params.merge(new_param).merge(only_path: true, script_name: nil).permit!
        end

    end
  end
end
