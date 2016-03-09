RSpec.shared_context 'query repository', type: :repository do
  def i18n(value, locale = :en)
    {locale.to_s => value}
  end

  def stringify_keys(hash)
    hash.reduce({}) do |memo, (key, value)|
      memo.tap { |m| m[key.to_s] = value }
    end
  end

  def page_attributes(data)
    {}.tap do |attrs|
      attrs['_fullpath'] ||= 'foo/bar'
      attrs['template_path'] ||= i18n(attrs['_fullpath'] + '.liquid')
      attrs['parent_ids'] = []
    end.merge stringify_keys(data)
  end

  let(:collection) { [] }
  let(:adapter) do
    Locomotive::Steam::FilesystemAdapter.new(nil).tap do |adapter|
      allow(adapter).to receive(:collection) { collection }
      allow(adapter).to receive(:cache) do
        double('Cache').tap do |cache|
          expect(cache).to receive(:fetch) { |&block| block.call }
        end
      end
    end
  end
  let(:site) { double 'Site', _id: 'demo', locales: [:en] }
  let(:repository) { described_class.new adapter, site, :en }

  before do
    allow(Time).to receive(:zone) { Time }
  end
end
