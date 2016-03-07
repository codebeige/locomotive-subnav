require 'spec_helper'
require_relative 'navigation_examples'

describe '{% subnav %}', type: :template do

  include_examples 'navigation'

  before do
    allow(page_repository).to receive(:ancestors_with_children) { [page] }
  end

  it 'renders container' do
    render
    expect(rendered).to have_tag('nav.subnav')
  end

  it 'renders nested list for each ancestor level' do
    root      = page_double _id: '1', depth: 0
    top_level = page_double _id: '2', depth: 1
    allow(page).to receive(:depth) { 2 }
    allow(page).to receive(:parent_ids) { ['1', '2'] }
    allow(page).to receive(:title) { 'Current Page' }
    allow(page_repository).to receive(:ancestors_with_children).with(page) do
      [root, top_level, page]
    end
    render
    expect(rendered).to have_tag('ul li ul li ul li', text: 'Current Page')
  end

  it 'renders item for each sibling page' do
    sibling_1 = page_double title: 'Sibling 1'
    sibling_2 = page_double title: 'Sibling 2'
    allow(page).to receive(:title) { 'Current Page' }
    allow(page_repository).to receive(:ancestors_with_children).with(page) do
      [sibling_1, page, sibling_2]
    end
    render
    expect(rendered).to have_tag('ul') do
      with_text(/Sibling 1\s+Current Page\s+Sibling 2/)
    end
  end

  # TODO: it 'marks selected items'
  # TODO: it 'renders nested level inside selected item'
  # TODO: it 'marks current level'
  # TODO: it 'renders ancestor trail up to given level only'
end
