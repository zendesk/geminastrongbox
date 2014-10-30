require_relative '../test_helper'

class Helpers::GeminaboxTest < ActiveSupport::TestCase
  include Helpers::Geminabox

  describe 'gems' do
    let(:gem_cache) {{ 'test_gem' => true }}

    it 'links to local gem' do
      link = link_to_gem('test_gem')
      link.must_equal '<a href="/gems/gems/test_gem">test_gem</a>'
    end

    it 'links to remote gem' do
      link = link_to_gem('bundler')
      link.must_equal '<a href="https://rubygems.org/gems/bundler">bundler</a>'
    end

    it 'finds gem' do
      find_gem_by_name('test_gem').must_equal true
    end

    it 'does not find remote gems' do
      find_gem_by_name('bundler').must_be_nil
    end
  end
end
