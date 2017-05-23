class Baby < ActiveRecord::Base
  has_many :user_babies
  has_many :users, through: :user_babies
  has_many :sizes

  validates :name, :birthdate, presence: true

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

end
