require_relative 'tag'

module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Breadcrumbs < Tag
          def render(context)
            current_page = context.registers[:page]
            container 'breadcrumbs' do
              list do
                ancestors_and_self(current_page, context).map do |page|
                  attrs = page_attributes(page, context)
                  item attrs[:title], attrs[:path]
                end.join "\n"
              end
            end
          end

          protected

          def list
            %(<ol>#{indent yield}</ol>)
          end

          def ancestors_and_self(page, context)
            page_repository = context.registers[:services].repositories.page
            page_repository.ancestors_of(page).select { |p| display? p }
          end
        end
      end
    end
  end
end
