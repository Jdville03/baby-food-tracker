class User < ActiveRecord::Base
  has_many :user_babies
  has_many :babies, through: :user_babies

  validates :username, :name, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  has_secure_password

  extend Slugifiable::ClassMethods
  #include Slugifiable::InstanceMethods

  def slug
    self.username.downcase.gsub(/[\s\W]/, "-")
  end

end
