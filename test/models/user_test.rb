require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase
  describe 'system_user' do
    it 'creates the system user if it does not exist' do
      User.delete_all
      User.system_user.must_be :present?
      User.system_user.must_be :system_user?
    end

    it 'returns the system user if it exists' do
      existing_system_user = User.where(:email => 'system@example.com').first
      existing_system_user.must_be :present?
      existing_system_user.must_be :system_user?
      User.system_user.must_equal existing_system_user
    end
  end

  describe 'system_user?' do
    it 'is true when email is system@example.com' do
      User.new(:email => 'system@example.com').must_be :system_user?
    end

    it 'is false when email something else' do
      User.new(:email => 'dude@example.com').wont_be :system_user?
    end
  end

  describe 'update_or_create_by_auth' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        :provider => 'test',
        :uid => '1234',
        :info => OmniAuth::AuthHash.new(
          :email => 'test@example.com',
          :name => 'Tester Testings'
        )
      )
    end

    subject { User.update_or_create_by_auth(auth_hash) }

    describe 'when the user exists' do
      before do
        @existing_user = User.create!(:external_id => 'test-1234', :name => 'wrong', :email => 'wrong@example.com')
      end

      it 'updates the user' do
        subject.must_equal @existing_user
        subject.name.must_equal 'Tester Testings'
        subject.email.must_equal 'test@example.com'
      end
    end

    describe 'when the user does not exist' do
      before { User.delete_all }

      it 'creates the user' do
        subject.must_be :present?
        subject.external_id.must_equal 'test-1234'
        subject.name.must_equal 'Tester Testings'
        subject.email.must_equal 'test@example.com'
      end
    end
  end

  describe 'the last admin' do
    subject { users(:admin) }

    before { User.admin.count.must_equal 1 }

    it 'can not be destroyed' do
      subject.destroy.must_equal false
    end

    it 'can not be changes to an non-admin' do
      subject.is_admin = false
      subject.wont_be :valid?
    end
  end

  describe 'the non-last admin' do
    subject { users(:admin) }

    before do
      User.create!(:name => 'Other Admin', :email => 'other_admin@example.com', :is_admin => true)
      User.admin.count.must_be :>, 1
    end

    it 'can be destroyed' do
      subject.destroy.wont_equal false
    end

    it 'can not be changes to an non-admin' do
      subject.is_admin = false
      subject.must_be :valid?
    end
  end
end
