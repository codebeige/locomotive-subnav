require 'spec_helper'
require 'locomotive/steam/adapters/filesystem'

describe Locomotive::Steam::PageRepository, type: :repository do
  describe '#ancestors_with_children' do
    let(:collection) { [page_attributes(_id: '2.2', title: 'Wild Cherry')] }
    let(:page) { double 'Page', _id: '2.2', parent_ids: [] }

    def ids(set)
      set.map(&:_id)
    end

    it 'includes current page' do
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('2.2')
    end

    it 'incudes ancestor pages' do
      collection << page_attributes(_id: '0')
      collection << page_attributes(_id: '1.1')
      allow(page).to receive(:parent_ids) { ['0', '1.1'] }
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('0', '1.1')
    end
  end
end
