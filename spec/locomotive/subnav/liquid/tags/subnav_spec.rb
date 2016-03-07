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

  it 'renders nested level inside selected item' do
    selected_parent = page_double _id: '5', depth: 0, title: 'Cherries'
    allow(page).to receive(:depth) { 1 }
    allow(page).to receive(:parent_ids) { ['5'] }
    allow(page).to receive(:title) { 'Wild Cherry' }
    allow(page_repository).to receive(:ancestors_with_children).with(page) do
      [selected_parent, page]
    end
    render
    expect(rendered).to have_tag('li') do
      with_tag('a', text: 'Cherries')
      with_tag('ul li', text: 'Wild Cherry')
    end
  end

  it 'marks selected items' do
    parent = page_double _id: '3', title: 'We are here', depth: 0
    allow(page).to receive(:depth) { 1 }
    allow(page).to receive(:parent_ids) { ['3'] }
    allow(page_repository).to receive(:ancestors_with_children).with(page) do
      [parent, page]
    end
    render
    expect(rendered).to have_tag('li.selected', text: 'We are here')
  end

  it 'marks current page as being selected' do
    allow(page).to receive(:title) { 'Wild Cherry' }
    allow(page_repository).to receive(:ancestors_with_children).with(page) do
      [page]
    end
    render
    expect(rendered).to have_tag('li.selected', text: 'Wild Cherry')
  end

  it 'renders nested level inside selected item' do
    selected_parent = page_double _id: '5', depth: 0
    allow(page).to receive(:depth) { 1 }
    allow(page).to receive(:parent_ids) { ['5'] }
    allow(page).to receive(:title) { 'Wild Cherry' }
    allow(page_repository).to receive(:ancestors_with_children).with(page) do
      [selected_parent, page]
    end
    render
    expect(rendered).to have_tag('li.selected') do
      with_tag('ul li', text: 'Wild Cherry')
    end
  end

  # TODO: it 'marks current level'
  # TODO: it 'renders ancestor trail up to given level only'
end
