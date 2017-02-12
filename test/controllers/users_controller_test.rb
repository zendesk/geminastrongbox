require_relative '../test_helper'

class UsersControllerTest < ActionController::TestCase
  describe 'index' do
    when_not_logged_in do
      it 'denies access' do
        get :index
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin) do
      it 'forbids access' do
        get :index
        assert_response :forbidden
      end
    end

    when_logged_in_as(:admin) do
      it 'lists all non-system users' do
        get :index

        assert_select 'table#users' do
          assert_select 'tbody tr', User.not_system_user.count

          User.not_system_user.each do |user|
            assert_select 'tbody tr td.name', :text => user.name
          end
        end
      end
    end
  end

  describe 'make_admin' do
    when_not_logged_in do
      it 'denies access' do
        patch :make_admin, params: {:id => users(:non_admin).id}
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin) do
      it 'forbids access' do
        patch :make_admin, params: {:id => users(:non_admin).id}
        assert_response :forbidden
      end
    end

    when_logged_in_as(:admin) do
      it 'makes the user an admin' do
        patch :make_admin, params: {:id => users(:non_admin).id}
        users(:non_admin).reload.must_be :is_admin?
      end
    end
  end

  describe 'make_non_admin' do
    when_not_logged_in do
      it 'denies access' do
        patch :make_non_admin, params: {:id => users(:admin).id}
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin) do
      it 'forbids access' do
        patch :make_non_admin, params: {:id => users(:admin).id}
        assert_response :forbidden
      end
    end

    when_logged_in_as(:admin) do
      describe 'when this is the last admin' do
        before { User.admin.count.must_equal 1 }
        it 'does not make the user an non-admin' do
          patch :make_non_admin, params: {:id => users(:admin).id}
          users(:admin).reload.must_be :is_admin?
        end
      end

      describe 'when there are other admins' do
        before { User.create!(:name => 'Other Admin', :email => 'other_admin@example.com', :is_admin => true) }

        it 'makes the user an non-admin' do
          patch :make_non_admin, params: {:id => users(:admin).id}
          users(:admin).reload.wont_be :is_admin?
        end
      end
    end
  end

  describe 'destroy' do
    let(:user) { users(:admin) }
    when_not_logged_in do
      it 'denies access' do
        delete :destroy, params: {:id => user.id}
        assert_access_denied
      end
    end

    when_logged_in_as(:non_admin) do
      it 'forbids access' do
        delete :destroy, params: {:id => user.id}
        assert_response :forbidden
      end
    end

    when_logged_in_as(:admin) do
      describe 'when this is the last admin' do
        before { User.admin.count.must_equal 1 }
        it 'does not make the user an non-admin' do
          delete :destroy, params: {:id => user.id}
          User.where(:id => user.id).wont_be :empty?
        end
      end

      describe 'when there are other admins' do
        before { User.create!(:name => 'Other Admin', :email => 'other_admin@example.com', :is_admin => true) }

        it 'makes the user an non-admin' do
          delete :destroy, params: {:id => user.id}
          User.where(:id => user.id).must_be :empty?
        end
      end
    end
  end
end
