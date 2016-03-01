require 'spec_helper'

describe Locomotive::Subnav::Liquid::Tags::Breadcrumbs do
  let(:url_builder) do
    instance_double Locomotive::Steam::UrlBuilderService, url_for: '/foo/bar'
  end
  let(:services) { double 'Services', url_builder: url_builder }
  let(:site) { instance_double Locomotive::Steam::Site }
  let(:page) { double 'Page', title: 'Example Page' }
  let(:registers) { {site: site, page: page, services: services} }
  let(:context) { ::Liquid::Context.new({}, {}, registers) }

  def render(source, options = {})
    Locomotive::Steam::Liquid::Template.parse(source, options).render(context)
  end

  describe 'with defaults' do
    let(:source) { '{% breadcrumbs %}' }

    it 'renders container' do
      rendered = render(source)
      expect(rendered).to have_tag('nav.breadcrumbs')
    end

    it 'renders current level' do
      rendered = render(source)
      expect(rendered).to have_tag('nav ul.current')
    end

    it 'renders item for current page' do
      allow(url_builder).to receive(:url_for).with(page) { '/prunus/avium'  }
      allow(page).to receive(:title) { 'Wild Cherry' }
      rendered = render(source)
      expect(rendered).to have_tag('ul.current li.nav-item.current') do
        with_tag 'a',
          with: {href: '/prunus/avium'},
          text: 'Wild Cherry'
      end
    end
  end
end
