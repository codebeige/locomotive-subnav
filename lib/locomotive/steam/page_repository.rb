module Locomotive
  module Steam
    class PageRepository
      def ancestors_with_children(page, level = 0)
        all(k(:parent_id, :in) => page.parent_ids + [page._id, nil])
      end
    end
  end
end
