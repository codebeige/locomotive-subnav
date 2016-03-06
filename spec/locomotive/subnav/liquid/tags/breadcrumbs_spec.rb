require 'spec_helper'

describe '{% breadcrumbs %}', type: :template do

  it 'renders container' do
    render
    expect(rendered).to have_tag('nav.breadcrumbs ol')
  end

  it 'renders item for each page' do
    allow(page).to receive(:title) { 'Wild Cherry' }
    allow(url_builder).to receive(:url_for).with(page) { '/prunus/avium'  }
    render
    expect(rendered).to have_tag('ol li') do
      with_tag 'a',
        with: {href: '/prunus/avium'},
        text: 'Wild Cherry'
    end
  end

  it 'translates pages' do
    translated_page = page_double title: 'Wildkirsche'
    registers[:locale] = 'de'
    allow(site).to receive(:default_locale) { 'en' }
    allow(i18n).to receive(:new).with(page, 'de', 'en') { translated_page }
    render
    expect(rendered).to have_tag('ol li', text: 'Wildkirsche')
  end

  it 'skips unpublished pages' do
    allow(page).to receive(:published?) { false }
    render
    expect(rendered).to_not have_tag('ol li')
  end

  it 'skips unlisted pages' do
    allow(page).to receive(:listed?) { false }
    render
    expect(rendered).to_not have_tag('ol li')
  end

  it 'skips templates' do
    allow(page).to receive(:templatized?) { true }
    render
    expect(rendered).to_not have_tag('ol li')
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

  describe 'with level option' do
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
