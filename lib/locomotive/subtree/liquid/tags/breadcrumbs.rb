module Locomotive
  module Subtree
    module Liquid
      module Tags
        class Breadcrumbs < ::Liquid::Tag
          def render(context)
            <<-HTML
            <nav class="breadcrumbs">
              <ul>
                <li class="nav-item"><a href="/foo/bar">FOO | BAR</a></li>
              </ul>
            </nav>
            HTML
          end

        ::Liquid::Template.register_tag('breadcrumbs'.freeze, Breadcrumbs)
        end
      end
    end
  end
end
