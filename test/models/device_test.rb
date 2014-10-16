require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  subject { Device.create!(:user => users(:admin), :name => 'New Device') }

  it 'generates an identifier on creation' do
    subject.identifier.must_be :present?
  end

  it 'generates a password on creation' do
    subject.password.must_be :present?
    subject.password_digest.must_be :present?
  end
end
