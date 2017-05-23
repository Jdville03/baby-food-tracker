class User < ActiveRecord::Base
  has_many :user_babies
  has_many :babies, through: :user_babies

  validates :username, :email, presence: true
  has_secure_password

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

end
