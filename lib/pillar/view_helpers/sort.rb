module Pillar
  module ViewHelpers
    module Sort

      def pillar_sort_link(label, column)
        direction   = params[:direction] if current_column?(column)
        direction ||= column.options[:default_direction].to_s

        link_to(
          "#{label} #{column_icon(column, direction)}".html_safe,
          current_path_with_params(direction: flip_direction(column, direction), sort: column.param, page: nil)
        )
      end

      def pillar_sort_asc_icon
        "⯅"
      end

      def pillar_sort_desc_icon
        "⯆"
      end

      private

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
end
