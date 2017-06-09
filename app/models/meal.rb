class Meal < ActiveRecord::Base
  belongs_to :baby

  validates :entry_datetime, :food_type, presence: true
  validates :food_type, inclusion: { in: ["breast milk (breast)", "breast milk (bottle)", "formula", "solids"] }
  validates :amount, presence: true, if: "food_type == 'breast milk (bottle)' || food_type == 'formula'"
  validates :duration, presence: true, if: "food_type == 'breast milk (breast)'"
  validates :ingredients, presence: true, if: "food_type == 'solids'"
  
end
