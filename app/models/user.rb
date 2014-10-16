class User < ActiveRecord::Base
  has_many :devices

  validates_presence_of :name, :email

  def self.update_or_create_by_auth(auth_hash)
    identifier = "#{auth_hash.provider}-#{auth_hash.uid}"
    user = User.where(['external_id = ? OR email = ?', identifier, auth_hash.info.email]).first_or_initialize

    user.assign_attributes(
      :external_id => identifier,
      :email => auth_hash.info.email,
      :name => auth_hash.info.name
    )

    user.save!

    user
  end
end
