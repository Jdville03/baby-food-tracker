class Meal < ActiveRecord::Base
  belongs_to :baby

  validates :entry_date, :entry_time, :food_type, presence: true
  validate :entry_date_invalid
  validates :food_type, inclusion: { in: ["breast milk (breast)", "breast milk (bottle)", "formula", "solids"] }, if: "food_type.present?"
  validates :amount, presence: { message: "must be entered" }, if: "food_type == 'breast milk (bottle)' || food_type == 'formula'"
  validates :amount, numericality: { greater_than_or_equal_to: 0.25 }, if: "amount.present?"
  validates :duration, presence: { message: "must be entered" }, if: "food_type == 'breast milk (breast)'"
  validates :duration, numericality: { greater_than_or_equal_to: 0.25 }, if: "duration.present?"
  validates :ingredients, presence: { message: "must be entered" }, if: "food_type == 'solids'"
  validates :amount_type, presence: { message: "must be entered" }, if: "amount.present?"
  validates :amount_type, inclusion: { in: ["oz", "ml", "cup", "tbsp", "tsp"] }, if: "amount_type.present?"

  def entry_date_invalid
    if entry_date.present? && ((self.baby && entry_date < self.baby.birthdate) || entry_date > Date.current)
      errors.add(:entry_date, "can't be before baby's birthdate or in the future")
    end
  end

end
