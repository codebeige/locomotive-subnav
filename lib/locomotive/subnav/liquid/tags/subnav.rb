require_relative 'tag'

module Locomotive
  module Subnav
    module Liquid
      module Tags
        class Subnav < Tag
          def render(context)
            container 'subnav' do
              ''
            end
          end
        end
      end
    end
  end
end
