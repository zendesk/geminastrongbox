class Device < ActiveRecord::Base
  validates_presence_of :name, :user_id, :identifier, :password_digest
  validates_uniqueness_of :name, :scope => :user_id, :message => 'is already registered'

  belongs_to :user, :touch => true
  has_secure_password :validations => false

  before_validation :generate_identifier, :on => :create
  before_validation :generate_password, :on => :create

  def generate_token
    data = JSON.dump(id: id, time: Time.now.to_i)

    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = Rails.application.config.device_cipher_key
    iv = cipher.random_iv

    encrypted = cipher.update(data) + cipher.final
    CGI.escape(Base64.encode64(iv)) + ":" + CGI.escape(Base64.encode64(encrypted))
  end

  def self.find_by_token(iv, encrypted)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = Rails.application.config.device_cipher_key
    decipher.iv = iv

    plain = decipher.update(encrypted) + decipher.final
    hash = JSON.parse(plain)
    if Time.at(hash['time']) > Rails.application.config.token_expiration.ago
      find(hash['id'])
    else
      false
    end
  end

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
