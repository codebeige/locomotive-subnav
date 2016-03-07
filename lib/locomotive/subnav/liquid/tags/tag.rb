module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Tag < ::Liquid::Tag

          def self.inherited(subclass)
            tag_name = subclass.name.split('::').last.downcase.freeze
            ::Liquid::Template.register_tag(tag_name, subclass)
          end

          DEFAULT_ATTRIBUTES = {level: 0}.freeze

          def initialize(name, source, options = {})
            parsed_attributes = parse_attributes(source)
            @attributes = DEFAULT_ATTRIBUTES.merge(parsed_attributes)
          end

          def level
            @attributes[:level].to_i
          end

          protected

          def indent(markup, drop_leading_line_break = false)
            unless markup.nil?
              indented = %(#{markup.gsub(/^/, '  ')}\n)
              if drop_leading_line_break
                indented
              else
                %(\n#{indented})
              end
            else
              ''
            end
          end

          def container(name)
            %(<nav class="#{name}">#{indent yield}</nav>)
          end

          def list
            %(<ul>#{indent yield}</ul>)
          end

          def item(name = nil, label, path)
            markup = ''
            markup << if name then %(<li class="#{name}">) else '<li>' end
            link = %(<a href="#{path}">#{label}</a>)
            if block_given?
              markup << indent(link)
              markup << indent(yield, true)
            else
              markup << link
            end
            markup << '</li>'
          end

          def display?(page)
            page.depth >= level &&
            page.published? &&
            page.listed? &&
            !page.templatized?
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

          private

          def parse_attributes(source)
            {}.tap do |attributes|
              source.scan(::Liquid::TagAttributes) do |key, value|
                attributes[key.to_sym] = value.gsub(/['"]+/, '')
              end
            end
          end
        end
      end
    end
  end
end
