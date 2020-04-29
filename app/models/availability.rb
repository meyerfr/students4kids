class Availability < ApplicationRecord
  belongs_to :sitter, class_name: 'User'

  validate :start_time_in_future, :minimum_time_range, :availability_overlap

  def is_status?(status)
    self.status == status
  end

  # Validate whether the start time is in the future
  def start_time_in_future
    if start_time.present? && start_time < DateTime.now
      errors.add(:start_time, "cannot be in the past.")
    end
  end

  # Validate whether the end_time is at least 3 hrs after the start_time
  def minimum_time_range
    if start_time.present? && end_time.present? && end_time < (start_time.advance(:hours => 3))
      errors.add(:end_time, "has to be at least 3 hours after the start time.")
    end
  end

  # Validate whether the availability is not overlapping any already existing availabilities
  def availability_overlap
    if start_time.present? && end_time.present?
      Availability.where(sitter: sitter).each do |availability|
        if start_time > availability.start_time.advance(:hours => -0.5) && start_time < availability.end_time.advance(:hours => +0.5)
          errors.add(:start_time, "is within 30 minutes of or during another one of your availabilities.")
          break
        elsif end_time > availability.start_time.advance(:hours => -0.5) && end_time < availability.end_time.advance(:hours => +0.5)
          errors.add(:end_time, "is within 30 minutes of or during another one of your availabilities.")
          break
        end
      end
    end
  end
end
