require 'test_helper'

class GemAccessTest < ActionDispatch::IntegrationTest
  describe 'accessing the gems' do
    let(:gem_access_paths) {
      [
        '/gems/api/v1/dependencies',
        '/gems/specs.4.8.gz',
        '/gems/prerelease_specs.4.8.gz',
        '/gems/quick/Marshal.4.8/mickstaugaard-0.0.1.gemspec.rz',
        '/gems/gems/mickstaugaard-0.0.1.gem'
      ]
    }

    when_not_logged_in do
      it 'is denied' do
        gem_access_paths.each do |path|
          get path, {}, env
          assert_response :unauthorized
        end
      end
    end

    when_logged_in_as(:not_admin_laptop) do
      it 'is allowed' do
        gem_access_paths.each do |path|
          get path, {}, env
          assert_response :success
        end
      end

      it 'registers that the device was used' do
        current_device.used_at.must_be_nil
        get gem_access_paths.last, {}, env
        assert_response :success
        current_device.reload.used_at.wont_be_nil
      end
    end
  end
end
