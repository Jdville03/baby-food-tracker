class User < ActiveRecord::Base
  has_many :user_babies
  has_many :babies, through: :user_babies

  validates :username, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  has_secure_password

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

end
