class Baby < ActiveRecord::Base
  has_many :user_babies
  has_many :users, through: :user_babies

  validates :name, :birthdate, presence: true
  #validates :user, presence: true

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

end
