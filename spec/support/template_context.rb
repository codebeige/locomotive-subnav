RSpec.shared_context 'render template', type: :template do
  def page_double(attrs = {})
    double 'Page', {_id: '123',
                    title: 'Example Page',
                    published?: true,
                    listed?: true,
                    templatized?: false,
                    position: 99,
                    depth: 0,
                    parent_ids: []}.merge(attrs)
  end

  let(:page_repository) { instance_double Locomotive::Steam::PageRepository }
  let(:repositories) { double 'Repositories', page: page_repository }
  let(:url_builder) do
    instance_double Locomotive::Steam::UrlBuilderService, url_for: '/foo/bar'
  end
  let(:services) do
    double 'Services', url_builder: url_builder, repositories: repositories
  end
  let(:site) { instance_double Locomotive::Steam::Site, default_locale: nil}
  let(:page) { page_double title: 'Current Page' }
  let(:registers) do
    {site: site, page: page, services: services, locale: 'xx'}
  end
  let(:context) { ::Liquid::Context.new({}, {}, registers) }

  def i18n
    Locomotive::Steam::Decorators::I18nDecorator
  end

  before do
    allow(i18n).to receive(:new) { |page| page }
  end

  let(:source) { subject }

  def render(options = {})
    template = Locomotive::Steam::Liquid::Template.parse(source, options)
    @rendered = template.render(context)
  end

  def rendered
    @rendered
  end
end
