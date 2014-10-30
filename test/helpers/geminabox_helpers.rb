require_relative '../test_helper'
require 'minitest/mock'

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

  describe 'reverse dependencies' do
    def spec_for(name, number)
      dependencies = if specs.key?(name)
        specs[name][number.to_s].map do |gem, version|
          Gem::Dependency.new(gem, version)
        end
      else
        []
      end

      mock = Minitest::Mock.new
      mock.expect(:dependencies, dependencies)
    end

    def gem(name, version)
      Geminabox::GemVersion.new(name, Gem::Version.new(version), 'ruby')
    end

    let(:specs) {{
      'test_gem' => {
        '0.0.1' => { 'private_gem' => '>= 0' }
      },
      'specific_gem' => {
        '0.0.1' => { 'private_gem' => '0.0.2' }
      }
    }}

    let(:load_gems) {
      Geminabox::GemVersionCollection.new([
        ['private_gem', Gem::Version.new('0.0.1'), 'ruby'],
        ['private_gem', Gem::Version.new('0.0.2'), 'ruby'],
        ['test_gem', Gem::Version.new('0.0.1'), 'ruby'],
        ['specific_gem', Gem::Version.new('0.0.1'), 'ruby']
      ])
    }

    it 'works for gems with no reverse dependencies' do
      reverse_dependencies(gem('specific_gem', '0.0.1')).must_be_empty
      reverse_dependencies(gem('test_gem', '0.0.1')).must_be_empty
    end

    it 'works for a gem with non-specific dependencies' do
      dependents = reverse_dependencies(gem('private_gem', '0.0.1'))
      dependents.must_equal([Gem::Dependency.new('test_gem', '>= 0')])
    end

    it 'works for a gem with specific dependencies' do
      dependents = reverse_dependencies(gem('private_gem', '0.0.2'))
      dependents.must_equal([Gem::Dependency.new('specific_gem', '0.0.2'), Gem::Dependency.new('test_gem', '>= 0')])
    end
  end
end
