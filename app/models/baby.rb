class Baby < ActiveRecord::Base
  has_many :user_babies
  has_many :users, through: :user_babies
  has_many :sizes
  has_many :meals

  validates :name, :birthdate, presence: true
  has_secure_password

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
