class Size < ActiveRecord::Base
  belongs_to :baby

  # size object must have entry_date and one or both of height and weight
  validates :entry_date, presence: true
  validate :entry_date_invalid
  validate :height_and_or_weight_must_be_present
  validates :height, numericality: { greater_than_or_equal_to: 0.1 }, if: "height.present?"
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }, if: "weight.present?"

  def entry_date_invalid
    if entry_date.present? && ((self.baby && entry_date < self.baby.birthdate) || entry_date > Date.current)
      errors.add(:entry_date, "can't be before baby's birthdate or in the future")
    end
  end

  def height_and_or_weight_must_be_present
    if entry_date.present? && !height.present? && !weight.present?
      errors.add(:height, "and/or weight must be entered")
    end
  end

end
