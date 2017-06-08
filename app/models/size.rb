class Size < ActiveRecord::Base
  belongs_to :baby

  validates :entry_date, presence: true, if: "weight.present? || height.present?"
  validates :height, presence: { message: "must be given if weight is not entered" }, if: "entry_date.present? && !weight.present?"
  validates :weight, presence: { message: "must be given if height is not entered" }, if: "entry_date.present? && !height.present?"

end
