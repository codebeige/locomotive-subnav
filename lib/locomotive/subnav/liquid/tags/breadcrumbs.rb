module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Breadcrumbs < ::Liquid::Tag

          def render(context)
            current_page = context.registers[:page]
            wrapper do
              level('current') do
                attrs = page_attributes(current_page, context)
                item 'current', attrs[:title], attrs[:path]
              end
            end
          end

          protected

          def indent(markup)
            %(\n#{markup.gsub(/^/, '  ')}\n)
          end

          def wrapper
            %(<nav class="breadcrumbs">#{indent yield}</nav>)
          end

          def level(name = nil)
            attrs = if name then %( class="#{name}") else '' end
            %(<ul#{attrs}>#{indent yield}</ul>)
          end

          def item(name = nil, title, path)
            names = ['nav-item']
            names << name if name
            %(<li class="#{names.join ' '}"><a href="#{path}">#{title}</a></li>)
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
