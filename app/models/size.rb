class Size < ActiveRecord::Base
  belongs_to :baby

  validates :entry_date, presence: true
  validate :entry_date_invalid, :height_and_or_weight_must_be_present
  validates :height, numericality: { greater_than_or_equal_to: 0.1 }, if: "height.present?"
  validates :weight, numericality: { greater_than_or_equal_to: 0.1 }, if: "weight.present?"

  include ValidationMethods::InstanceMethods

  def height_and_or_weight_must_be_present
    if entry_date.present? && !height.present? && !weight.present?
      errors.add(:height, "and/or weight must be entered")
    end
  end

end
