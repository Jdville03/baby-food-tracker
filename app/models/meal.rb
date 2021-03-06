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

  include ValidationMethods::InstanceMethods

  def update_with_data(data)
    case data[:food_type]
    when "breast milk (breast)"
      self.duration = data[:duration]
    when "breast milk (bottle)", "formula"
      self.amount = data[:amount]
      self.amount_type = data[:amount_type]
    when "solids"
      self.ingredients = data[:ingredients]
      self.amount = data[:amount]
      if self.amount
        self.amount_type = data[:amount_type]
      else
        self.amount_type = nil
      end
    end

    self.entry_date = data[:entry_date]
    self.entry_time = data[:entry_time]
    self.food_type = data[:food_type]
    self.notes = data[:notes]
    self.save
  end
  
end
