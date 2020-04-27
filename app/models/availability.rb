class Availability < ApplicationRecord
  belongs_to :sitter, class_name: 'User'

  validate :start_time_in_future, :minimum_time_range, :overlap_check

  def is_status?(status)
    self.status == status
  end

  def start_time_in_future
    if start_time.present? && start_time < DateTime.now
      errors.add(:start_time, "cannot be in the past.")
    end
  end

  def minimum_time_range
    if start_time.present? && end_time.present? && end_time < (start_time.advance(:hours => 3))
      errors.add(:end_time, "has to be at least 3 hours after the start time.")
    end
  end

  def overlap_check
    if start_time.present? && end_time.present?
      Availability.where(sitter: sitter).each do |availability|
        if start_time > availability.start_time.advance(:hours => -0.5)
          errors.add(:start_time, "- you have another availability ending within 30 minutes of or during the availability you are trying to add.")
          break
        elsif end_time < availability.end_time.advance(:hours => 0.5)
          errors.add(:end_time, "- you have another availability starting within 30 minutes of or during the availability you are trying to add.")
          break
        end
      end
    end
  end
end
