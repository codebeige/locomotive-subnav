require_relative 'tag'

module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Subnav < Tag
          def render(context)
            current_page = context.registers[:page]
            container 'subnav' do
              levels = current_branch(current_page, context)
              render_levels(levels, current_page.parent_ids, context)
            end
          end

          protected

          def render_levels(levels, selection, context)
            return if levels.empty?
            current_level = levels.first
            rest = levels.drop(1)
            list do
              current_level.map do |page|
                render_item(page, context) do
                  if selection.include? page._id
                    render_levels(rest, selection, context)
                  end
                end
              end.join "\n"
            end
          end

          def current_branch(page, context)
            page_repository = context.registers[:services].repositories.page
            pages = page_repository.ancestors_with_children(page)
            pages.select { |p| display? p }.group_by(&:depth).values
          end
        end
      end
    end
  end
end