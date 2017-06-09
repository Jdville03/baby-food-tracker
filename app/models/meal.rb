class Meal < ActiveRecord::Base
  belongs_to :baby

  validates :entry_date, :entry_time, :food_type, presence: true
  validates :food_type, inclusion: { in: ["breast milk (breast)", "breast milk (bottle)", "formula", "solids"] }
  validates :amount, presence: { message: "must be entered" }, if: "food_type == 'breast milk (bottle)' || food_type == 'formula'"
  validates :duration, presence: { message: "must be entered" }, if: "food_type == 'breast milk (breast)'"
  validates :ingredients, presence: { message: "must be entered" }, if: "food_type == 'solids'"

end
