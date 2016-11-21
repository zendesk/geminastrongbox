require_relative '../test_helper'

class DevicesControllerTest < ActionController::TestCase
  describe 'index' do
    when_not_logged_in do
      it 'denies access' do
        get :index
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin, :admin) do
      it 'lists all my devices and a link to create a new one' do
        get :index

        assert_select '#devices table' do
          assert_select 'tr', current_user.devices.count + 1

          current_user.devices.each do |device|
            assert_select 'tr td.name', :text => device.name
          end

          assert_select 'tr td a[href=?]', new_device_path
        end
      end
    end
  end

  describe 'new' do
    when_not_logged_in do
      it 'denies access' do
        get :new
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin, :admin) do
      it 'asks for a the name of the new device' do
        get :new
        assert_select 'form[action=?]', devices_path do
          assert_select "input[type=text][name='device[name]']"
        end
      end
    end
  end

  describe 'create' do
    let(:params) do
      {
        :device => {
          :name => 'New Laptop'
        }
      }
    end

    when_not_logged_in do
      it 'denies access' do
        post :create, params
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin, :admin) do
      before { post :create, params }

      describe 'when the device can not be saved' do
        let(:params) do
          {
            :device => {
              :name => current_user.devices.first.name
            }
          }
        end

        it 'rerenders the form with an error' do
          assert_select 'form[action=?]', devices_path do
            assert_select "input[type=text][name='device[name]'][value=?]", current_user.devices.first.name
          end

          assert_select 'p.text-danger', :text => 'Name is already registered'
        end
      end

      describe 'when the device is saved' do
        let(:device) { current_user.devices.find_by :name => 'New Laptop' }

        it 'render instructions for using the device' do
          assert_select 'code', :text => /bundle config --global http:\/\/test.host\/gems\/ #{device.identifier}:[\S]+/
        end
      end
    end
  end

  describe 'destroy' do
    when_not_logged_in do
      it 'denies access' do
        delete :destroy, :id => 1
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin, :admin) do
      let(:device) { current_user.devices.last }

      it 'destroys the device' do
        delete :destroy, :id => device.id
        Device.where(:id => device.id).must_be :empty?
      end
    end
  end
end
