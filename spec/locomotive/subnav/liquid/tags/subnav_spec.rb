require 'spec_helper'
require_relative 'navigation_examples'

describe '{% subnav %}', type: :template do

  include_examples 'navigation'

  it 'renders container' do
    render
    expect(rendered).to have_tag('nav.subnav')
  end
end
