require 'spec_helper'
require_relative 'navigation_examples'

describe '{% breadcrumbs %}', type: :template do

  before do
    allow(page_repository).to receive(:ancestors_of) { [page] }
  end

  include_examples 'navigation'

  it 'renders container' do
    render
    expect(rendered).to have_tag('nav.breadcrumbs ol')
  end

  describe 'with defaults' do
    let(:source) { '{% breadcrumbs %}' }

    it 'renders full ancestor trail' do
      allow(page).to receive(:title) { 'Wild Cherry' }
      parent = page_double(title: 'Cherries')
      parent_of_parent = page_double(title: 'Index')
      allow(page_repository).to receive(:ancestors_of).with(page) do
        [parent_of_parent, parent, page]
      end
      render
      expect(rendered).to have_tag('ol') do
        with_text(/Index\s+Cherries\s+Wild Cherry/)
      end
    end
  end

  describe 'with level option given' do
    let(:source) { '{% breadcrumbs level: 1 %}' }

    it 'renders ancestor trail up to given level only' do
      allow(page).to receive(:depth) { 2 }
      top_level = page_double(title: 'Top Level', depth: 1)
      root = page_double(title: 'Index', depth: 0)
      allow(page_repository).to receive(:ancestors_of).with(page) do
        [root, top_level, page]
      end
      render
      expect(rendered).to have_tag('ol') do
        without_tag('li', text: 'Index')
      end
    end
  end
end
