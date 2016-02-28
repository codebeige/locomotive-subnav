require 'spec_helper'

describe Locomotive::Subnav::Liquid::Tags::Breadcrumbs do
  let(:context) { ::Liquid::Context.new }

  def render(source, options = {})
    Locomotive::Steam::Liquid::Template.parse(source, options).render(context)
  end

  describe 'with defaults' do
    let(:source) { '{% breadcrumbs %}' }

    it 'renders container' do
      rendered = render(source)
      expect(rendered).to have_tag('nav.breadcrumbs')
    end
  end
end
