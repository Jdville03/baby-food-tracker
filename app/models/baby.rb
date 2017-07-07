class Baby < ActiveRecord::Base
  has_many :user_babies
  has_many :users, through: :user_babies
  has_many :sizes
  has_many :meals

  validates :name, :birthdate, presence: true
  validate :birthdate_cannot_be_in_the_future
  has_secure_password

  def birthdate_cannot_be_in_the_future
    if birthdate > Date.current
      errors.add(:birthdate, "can't be in the future")
    end
  end

  DAYS_IN_MONTH  = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def age(as_of_date)
    borrowed_month = false
    if as_of_date.leap?
      DAYS_IN_MONTH[2] = 29
    end
    days = as_of_date.day - birthdate.day
    months = as_of_date.month - birthdate.month
    years = as_of_date.year - birthdate.year
    if days < 0
      days = DAYS_IN_MONTH[birthdate.month] - birthdate.day + as_of_date.day + 1
      months -= 1
      borrowed_month = true
    end
    if months < 0
      months = 12 - birthdate.month + as_of_date.month
      if borrowed_month == true
        months -= 1
      end
      years -= 1
    end
    # Error-handling for future date
    if years < 0
      years, months, days = 0, 0, 0
    end
    readable_age(years, months, days)
  end

  def readable_age(years, months, days)
    age_array = []
    age_array << plural('year', years) if years != 0
    age_array << plural('month', months) if months != 0
    age_array << plural('day', days) if days != 0
    if age_array.empty?
      "just born!"
    else
      "#{age_array.join(', ')} old"
    end
  end

  def plural(word, value)
    "#{value.to_s} #{word}#{value > 1 ? 's' : ''}"
  end

  def meals_by_time_frame(time_frame)
    case time_frame
    when "today"
      self.meals.select{|meal| meal.entry_date == Date.current}
    when "last_3_days"
      self.meals.select{|meal| meal.entry_date > Date.current - 3}
    when "week"
      self.meals.select{|meal| meal.entry_date.cweek == Date.current.cweek && meal.entry_date.cwyear == Date.current.cwyear}
    when "last_7_days"
      self.meals.select{|meal| meal.entry_date > Date.current - 7}
    when "month"
      self.meals.select{|meal| meal.entry_date.month == Date.current.month && meal.entry_date.year == Date.current.year}
    when "all"
      self.meals
    end
  end

end
