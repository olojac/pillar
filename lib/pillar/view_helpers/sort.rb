module Pillar
  module ViewHelpers
    module Sort

      def pillar_sort_link(pillar, name, label)
        column           = pillar.sort.columns[name]
        direction        = column.next_direction(params)
        param_hash       = pillar.sort.param(column.param, direction)

        param_hash[pillar.paginate.param] = nil if pillar.paginate

        link_to(
          pillar_sort_label(label, column_icon(column, params)),
          current_path_with_params(param_hash)
        )
      end

      def pillar_sort_label(text, icon)
        "#{text} #{icon}".html_safe
      end

      def pillar_sort_asc_icon
        "⯅"
      end

      def pillar_sort_desc_icon
        "⯆"
      end

      private

        def column_icon(column, params)
          return "" unless column.selected?(params)

          case column.direction(params)
          when "asc"
            pillar_sort_asc_icon
          when "desc"
            pillar_sort_desc_icon
          end
        end

        def current_path_with_params(new_param = {})
          params.merge(new_param).merge(only_path: true, script_name: nil).permit!
        end

    end
  end
end
