require_relative '../test_helper'

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

      it 'blocks bundler < 1.6.5' do
        gem_access_paths.each do |path|
          get path, {}, env.merge('HTTP_USER_AGENT' => 'bundler/v1.0.0')
          assert_response :forbidden
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

  describe "uploader tracking" do
    when_logged_in_as(:not_admin_laptop) do
      it 'tracks uploader' do
        uploaded = 'test/data/gems/pru-0.2.0.gem'
        File.unlink(uploaded) if File.exist?(uploaded)

        begin
          file = fixture_file_upload('test/data/pru-0.2.0.gem')
          post '/gems/upload', {file: file}, env
          assert_response :success
          Uploader.last.attributes.except('id', 'created_at').must_equal(
            "gem_name" => "pru",
            "gem_version" => "0.2.0",
            "user_id" => current_user.id
          )
        ensure
          File.unlink(uploaded) if File.exist?(uploaded)
        end
      end

      it 'shows uploader' do
        Uploader.create!(
          gem_name: 'mickstaugaard',
          gem_version: '0.0.1',
          user_id: users(:admin).id
        )
        get '/gems/gems/mickstaugaard', {}, env
        assert_response :success
        response.body.must_include "Uploaded by #{users(:admin).email}"
      end

      it 'does not fail with unknown uploader' do
        get '/gems/gems/mickstaugaard', {}, env
        assert_response :success
      end
    end
  end
end
