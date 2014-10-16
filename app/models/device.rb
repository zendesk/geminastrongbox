class Device < ActiveRecord::Base
  validates_presence_of :name, :user_id, :identifier, :password_digest
  validates_uniqueness_of :name, :scope => :user_id, :message => 'is already registered'

  belongs_to :user, :touch => true
  has_secure_password :validations => false

  before_validation :generate_identifier, :on => :create
  before_validation :generate_password, :on => :create

  def used!
    update_attribute(:used_at, Time.now)
  end

  def used?
    !!used_at
  end

  protected

  def generate_identifier
    self.identifier ||= SecureRandom.urlsafe_base64
  end

  def generate_password
    self.password ||= SecureRandom.urlsafe_base64
  end
end
