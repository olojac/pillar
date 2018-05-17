module Pillar
  module ViewHelpers

    def pillar_sort_link(label, column)
      direction   = params[:direction] if current_column?(column)
      direction ||= column.options[:default_direction].to_s

      link_to(
        "#{label} #{column_icon(column, direction)}".html_safe,
        current_path_with_params({ direction: flip_direction(column, direction), sort: column.param, page: nil })
      )
    end

    def pillar_paginate(paginate_store, total = nil)
      page      = (params[:page] || 0).to_i
      max       =  max_page(paginate_store.options[:per_page], total)
      prev_link = link_to(pillar_paginate_prev_label, current_path_with_params({ page: page - 1 })) if page > 0
      next_link = link_to(pillar_paginate_next_label, current_path_with_params({ page: page + 1 })) if page < max

      "<div class='paginate'>" \
        "<div class='prev'>#{prev_link || pillar_paginate_prev_label}</div>" \
        "<div class='next'>#{next_link || pillar_paginate_next_label}</div>" \
      "</div>".html_safe
    end

    def pillar_sort_asc_icon
      "⯅"
    end

    def pillar_sort_desc_icon
      "⯆"
    end

    def pillar_paginate_next_label
      "Next ⯈"
    end

    def pillar_paginate_prev_label
      "⯇ Prev"
    end

    private

      def max_page(per_page, total)
        return Float::INFINITY if total.nil?
        max  = total / per_page - 1
        rest = total % per_page
        max += 1 if rest > 0

        return max
      end

      def current_column?(column)
        params[:sort] == column.param.to_s
      end

      def column_icon(column, direction)
        return "" unless current_column?(column)

        case direction
        when "asc"
          pillar_sort_asc_icon
        when "desc"
          pillar_sort_desc_icon
        end
      end

      def flip_direction(column, current_direction)
        return current_direction unless current_column?(column)

        case current_direction
        when "asc"
          "desc"
        when "desc"
          "asc"
        end
      end

      def current_path_with_params(new_param = {})
        params.merge(new_param).merge(only_path: true, script_name: nil).permit!
      end

  end
end
