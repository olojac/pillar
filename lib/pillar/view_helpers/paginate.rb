module Pillar
  module ViewHelpers
    module Paginate

      def pillar_paginate(pillar, item_count)
        current = pillar.paginate.page(params)
        pages   = pillar.paginate.pages(current, item_count)

        content_tag(:ul, class: "pagination") {
          pages.each { |page|
            concat(page == :sep ? pillar_pageinate_seperatior : pillar_paginate_item(page, current))
          }
        }
      end

      def pillar_paginate_item(page, current)
        classes = page == current ? "page-item active" : "page-item"
        content_tag(:li, link_to(page, current_path_with_params(page: page), class: "page-link"), class: classes)
      end

      def pillar_pageinate_seperatior
        content_tag(:li, content_tag(:span, "...", class: "page-link"), class: "page-item disabled") 
      end

      private

        def current_path_with_params(new_param = {})
          params.merge(new_param).merge(only_path: true, script_name: nil).permit!
        end

    end
  end
end
