class Size < ActiveRecord::Base
  belongs_to :baby

  # size object must have entry_date and one or both of height and weight
  validates :entry_date, presence: true, uniqueness: { message: "has already been added."}
  validates :height, presence: { message: "must be entered if weight is not entered" }, if: "entry_date.present? && !weight.present?"
  validates :weight, presence: { message: "must be entered if height is not entered" }, if: "entry_date.present? && !height.present?"

end
