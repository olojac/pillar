module Pillar
  module ViewHelpers
    module Filter

      def pillar_filter(filter)
        form_tag("", method: :get, class: "filter") {
          concat content_tag(:div, class: "input-group") {
            concat text_field_tag(filter.param, params[filter.param], class: "form-control")
            concat content_tag(:div, class: "input-group-append") {
              concat link_to("Clear", params.merge(filter: "").permit!, class: "btn btn-outline-secondary")
              concat button_tag("Filter", name: "", class: "btn btn-primary")
            }
          }
        }
      end

    end
  end
end
