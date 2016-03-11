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
              selection = current_page.parent_ids.push + [current_page._id]
              render_levels(levels, selection, context)
            end
          end

          def collapsed_levels
            @_collapsed_levels ||= [*@attributes[:collapse]].map(&:to_i)
          end

          protected

          def render_levels(levels, selection, context)
            return if levels.empty?
            level = levels.first
            rest = levels.drop(1)
            name = 'current' if current_level?(level, selection)
            list(name) do
              level.map do |page|
                attrs = page_attributes(page, context)
                if selected?(page, selection)
                  item 'selected', attrs[:title], attrs[:path] do
                    render_levels rest, selection, context
                  end
                elsif !collapsed_levels.include? page.depth
                  item(attrs[:title], attrs[:path])
                end
              end.compact.join "\n"
            end
          end

          def current_branch(page, context)
            page_repository = context.registers[:services].repositories.page
            pages = page_repository.ancestors_with_children(page, level)
            pages.select { |p| display? p }.group_by(&:depth).values
          end

          private

          def current_level?(level, selection)
            level.map(&:_id).include? selection.last
          end

          def selected?(page, selection)
            selection.include? page._id
          end
        end
      end
    end
  end
end
