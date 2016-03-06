require 'spec_helper'

describe '{% subnav %}', type: :template do
  it 'renders container' do
    render
    expect(rendered).to have_tag('nav.subnav')
  end
end
