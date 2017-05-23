class UserBaby < ActiveRecord::Base
  belongs_to :user
  belongs_to :baby
end
