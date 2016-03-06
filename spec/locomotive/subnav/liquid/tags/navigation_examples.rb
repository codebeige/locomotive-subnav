RSpec.shared_examples 'navigation' do
  it 'renders item for each page' do
    allow(page).to receive(:title) { 'Wild Cherry' }
    allow(url_builder).to receive(:url_for).with(page) { '/prunus/avium'  }
    render
    expect(rendered).to have_tag('li') do
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
    expect(rendered).to have_tag('li', text: 'Wildkirsche')
  end

  it 'skips unpublished pages' do
    allow(page).to receive(:published?) { false }
    render
    expect(rendered).to_not have_tag('li')
  end

  it 'skips unlisted pages' do
    allow(page).to receive(:listed?) { false }
    render
    expect(rendered).to_not have_tag('li')
  end

  it 'skips templates' do
    allow(page).to receive(:templatized?) { true }
    render
    expect(rendered).to_not have_tag('li')
  end
end
