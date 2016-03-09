require 'spec_helper'
require 'locomotive/steam/adapters/filesystem'

describe Locomotive::Steam::PageRepository, type: :repository do
  describe '#ancestors_with_children' do
    let(:collection) do
      [
        page_attributes(_id: '0',     _fullpath: ''),
        page_attributes(_id: '1',     _fullpath: 'apples'),
        page_attributes(_id: '1.1',   _fullpath: 'apples/gala'),
        page_attributes(_id: '1.2',   _fullpath: 'apples/jonagold'),
        page_attributes(_id: '2',     _fullpath: 'pears'),
        page_attributes(_id: '2.1',   _fullpath: 'pears/snow-pear'),
        page_attributes(_id: '3',     _fullpath: 'cherries'),
        page_attributes(_id: '3.1',   _fullpath: 'cherries/hill-cherry'),
        page_attributes(_id: '3.1.1', _fullpath: 'cherries/hill-cherry/fruit'),
        page_attributes(_id: '3.2',   _fullpath: 'cherries/wild-cherry'),
        page_attributes(_id: '3.2.1', _fullpath: 'cherries/wild-cherry/fruit'),
        page_attributes(_id: '3.3',   _fullpath: 'cherries/taiwan-cherry'),
      ]
    end

    let(:page) do
      double 'Page', _id: '3.2',
                     fullpath: 'cherries/wild-cherry',
                     parent_ids: ['0', '3']
    end

    def ids(records)
      records.map(&:_id)
    end

    it 'includes current page' do
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('3.2')
    end

    it 'incudes ancestor pages' do
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('3', '0')
    end

    it 'includes siblings of ancestors' do
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('1', '2')
    end

    it 'includes children of ancestors' do
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('3.1', '3.3')
    end

    it 'includes children of self' do
      result = repository.ancestors_with_children(page)
      expect(ids result).to include('3.2.1')
    end

    it 'does not include children of siblings' do
      result = repository.ancestors_with_children(page)
      expect(ids result).not_to include('1.1', '1.2', '2.1', '3.1.1')
    end

    it 'fetches ancestors up to given level only' do
      result = repository.ancestors_with_children(page, 1)
      expect(ids result).not_to include('0')
    end
  end
end
