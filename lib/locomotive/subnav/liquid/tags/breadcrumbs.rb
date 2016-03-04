module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Breadcrumbs < ::Liquid::Tag

          def render(context)
            current_page = context.registers[:page]
            container do
              list do
                attrs = page_attributes(current_page, context)
                item attrs[:title], attrs[:path]
              end
            end
          end

          protected

          def indent(markup)
            %(\n#{markup.gsub(/^/, '  ')}\n)
          end

          def container
            %(<nav class="breadcrumbs">#{indent yield}</nav>)
          end

          def list
            %(<ol>#{indent yield}</ol>)
          end

          def item(label, path)
            %(<li><a href="#{path}">#{label}</a></li>)
          end

          def page_attributes(page, context)
            url_builder = context.registers[:services].url_builder
            {title: page.title, path: url_builder.url_for(page)}
          end

        ::Liquid::Template.register_tag('breadcrumbs'.freeze, Breadcrumbs)
        end
      end
    end
  end
end
