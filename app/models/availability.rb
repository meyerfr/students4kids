class Availability < ApplicationRecord
  # Associations
  belongs_to :sitter, class_name: 'User'

  # Attribute Validations
  validate :start_time_in_future
  validate :minimum_time_range
  validate :availability_overlap
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :sitter_id, presence: true

  # Attribute Validation Functions
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

  def availability_overlap
    if start_time.present? && end_time.present?
      Availability.where(sitter: sitter).each do |availability|
        if id != availability.id
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

  # Model Functions
  def is_status?(status)
    self.status == status
  end
end
