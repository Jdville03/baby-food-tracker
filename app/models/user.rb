class User < ActiveRecord::Base
  has_many :user_babies
  has_many :babies, through: :user_babies

  validates :username, :name, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  has_secure_password

  def slug
    self.username.downcase.gsub(/[\s\W]/, "-")
  end

  def self.find_by_slug(slug)
    self.all.detect{|user| user.slug == slug}
  end

end
