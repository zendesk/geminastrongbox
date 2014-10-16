class User < ActiveRecord::Base
  SYSTEM_USER_EMAIL = 'system@example.com'.freeze

  has_many :devices

  validates_presence_of :name, :email

  def system_user?
    email == SYSTEM_USER_EMAIL
  end

  def self.not_system_user
    where('email != ?', SYSTEM_USER_EMAIL)
  end

  def self.admin
    where(:is_admin => true)
  end

  def self.update_or_create_by_auth(auth_hash)
    identifier = "#{auth_hash.provider}-#{auth_hash.uid}"
    user = User.where(:external_id => identifier).first_or_initialize

    user.assign_attributes(
      :email => auth_hash.info.email,
      :name => auth_hash.info.name
    )

    if !user.system_user? && not_system_user.count == 0
      # this is the first user we are creating
      user.is_admin = true
    end

    user.save!

    user
  end

  def self.system_user
    find_or_create_by!(:external_id => 'system') do |user|
      user.name = 'System User'
      user.email = SYSTEM_USER_EMAIL
    end
  end
end
