class Size < ActiveRecord::Base
  belongs_to :baby

  validates :entry_date, presence: true, if: "weight.present? || height.present?"
end
