require 'spec_helper'

describe Locomotive::Subnav::Liquid::Tags::Breadcrumbs do

  def page_double(attrs)
    double 'Page', {title: 'Example Page',
                    published?: true,
                    listed?: true,
                    templatized?: false}.merge(attrs)
  end

  let(:page_repository) do
    instance_double Locomotive::Steam::PageRepository, ancestors_of: [page]
  end
  let(:repositories) { double 'Repositories', page: page_repository }
  let(:url_builder) do
    instance_double Locomotive::Steam::UrlBuilderService, url_for: '/foo/bar'
  end
  let(:services) do
    double 'Services', url_builder: url_builder, repositories: repositories
  end
  let(:i18n) { Locomotive::Steam::Decorators::I18nDecorator }
  let(:site) { instance_double Locomotive::Steam::Site, default_locale: nil}
  let(:page) { page_double title: 'Current Page' }
  let(:registers) do
    {site: site, page: page, services: services, locale: 'xx'}
  end
  let(:context) { ::Liquid::Context.new({}, {}, registers) }

  def render(source, options = {})
    Locomotive::Steam::Liquid::Template.parse(source, options).render(context)
  end

  before do
    allow(i18n).to receive(:new) { |page| page }
  end

  describe 'with defaults' do
    let(:source) { '{% breadcrumbs %}' }

    it 'renders container' do
      rendered = render(source)
      expect(rendered).to have_tag('nav.breadcrumbs ol')
    end

    it 'renders item for each page' do
      allow(page).to receive(:title) { 'Wild Cherry' }
      allow(url_builder).to receive(:url_for).with(page) { '/prunus/avium'  }
      rendered = render(source)
      expect(rendered).to have_tag('ol li') do
        with_tag 'a',
          with: {href: '/prunus/avium'},
          text: 'Wild Cherry'
      end
    end

    it 'translates pages' do
      translated_page = double 'I18n Decorated Page', title: 'Wildkirsche'
      registers[:locale] = 'de'
      allow(site).to receive(:default_locale) { 'en' }
      allow(i18n).to receive(:new).with(page, 'de', 'en') { translated_page }
      rendered = render(source)
      expect(rendered).to have_tag('ol li', text: 'Wildkirsche')
    end

    it 'renders item for all ancestor pages' do
      allow(page).to receive(:title) { 'Wild Cherry' }
      parent = page_double(title: 'Cherries')
      parent_of_parent = page_double(title: 'Index')
      allow(page_repository).to receive(:ancestors_of).with(page) do
        [parent_of_parent, parent, page]
      end
      rendered = render(source)
      expect(rendered).to have_tag('ol') do
        with_text(/Index\s+Cherries\s+Wild Cherry/)
      end
    end

    it 'skips unpublished pages' do
      allow(page).to receive(:published?) { false }
      rendered = render(source)
      expect(rendered).to_not have_tag('ol li')
    end

    it 'skips unlisted pages' do
      allow(page).to receive(:listed?) { false }
      rendered = render(source)
      expect(rendered).to_not have_tag('ol li')
    end

    it 'skips templates' do
      allow(page).to receive(:templatized?) { true }
      rendered = render(source)
      expect(rendered).to_not have_tag('ol li')
    end
  end
end
