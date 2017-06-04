class Meal < ActiveRecord::Base
  belongs_to :baby

  validates :entry_datetime, :food_type, presence: true
  validates :food_type, inclusion: { in: ["breast milk", "formula", "solids"] }
  validates :amount_duration, presence: true, if: "food_type == 'breast milk' || food_type == 'formula'"
  validates :notes, presence: true, if: "food_type == 'solids'"
end
