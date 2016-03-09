module Locomotive
  module Steam
    class PageRepository
      def ancestors_with_children(page, level = 0)
        ancestors_of(page)
      end
    end
  end
end
