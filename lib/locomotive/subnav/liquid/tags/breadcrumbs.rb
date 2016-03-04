module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Breadcrumbs < ::Liquid::Tag

          def render(context)
            current_page = context.registers[:page]
            container do
              list do
                ancestors_and_self(current_page, context).map do |page|
                  attrs = page_attributes(page, context)
                  item attrs[:title], attrs[:path]
                end.join "\n"
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
            translated_page = translate_page(page, context)
            {title: translated_page.title,
             path: url_builder.url_for(translated_page)}
          end

          def translate_page(page, context)
            Locomotive::Steam::Decorators::I18nDecorator.new(
              page,
              context.registers[:locale],
              context.registers[:site].default_locale
            )
          end

          def ancestors_and_self(page, context)
            page_repository = context.registers[:services].repositories.page
            page_repository.ancestors_of(page).select { |p| display? p }
          end

          def display?(page)
            page.published? && page.listed? && !page.templatized?
          end

        ::Liquid::Template.register_tag('breadcrumbs'.freeze, Breadcrumbs)
        end
      end
    end
  end
end
