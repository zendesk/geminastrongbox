class User < ActiveRecord::Base
  SYSTEM_USER_EMAIL = 'system@example.com'.freeze

  has_many :devices

  validates_presence_of :name, :email

  before_destroy :dont_destroy_last_admin
  validate :dont_lose_last_admin, :on => :update

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

  def self.safe_to_remove_admin?
    User.admin.count > 1
  end

  protected

  def dont_destroy_last_admin
    if is_admin? && !self.class.safe_to_remove_admin?
      errors.add(:base, :cant_remove_last_admin)
      false
    end
  end

  def dont_lose_last_admin
    if is_admin_changed? && !is_admin? && !self.class.safe_to_remove_admin?
      errors.add(:base, :cant_remove_last_admin)
    end
  end
end
