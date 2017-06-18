module ValidationMethods

  module InstanceMethods
    def entry_date_invalid
      if entry_date.present? && ((self.baby && entry_date < self.baby.birthdate) || entry_date > Date.current)
        errors.add(:entry_date, "can't be before baby's birthdate or in the future")
      end
    end
  end

end
