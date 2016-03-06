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

          def self.default_attributes
            DEFAULT_ATTRIBUTES
          end

          def initialize(name, source, options = {})
            default_attributes = self.class.default_attributes
            parsed_attributes = parse_attributes(source)
            @attributes = default_attributes.merge(parsed_attributes)
          end

          def level
            @attributes[:level].to_i
          end

          protected

          def parse_attributes(source)
            {}.tap do |attributes|
              source.scan(::Liquid::TagAttributes) do |key, value|
                attributes[key.to_sym] = value.gsub(/['"]+/, '')
              end
            end
          end

          def indent(markup)
            %(\n#{markup.gsub(/^/, '  ')}\n)
          end

          def container(name)
            %(<nav class="#{name}">#{indent yield}</nav>)
          end
        end
      end
    end
  end
end
