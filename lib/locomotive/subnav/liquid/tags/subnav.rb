require_relative 'tag'

module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Subnav < Tag
          def render(context)
            current_page = context.registers[:page]
            container 'subnav' do
              page = current_page
              if display?(page)
                list do
                  render_item page, context
                end
              end
            end
          end
        end
      end
    end
  end
end
