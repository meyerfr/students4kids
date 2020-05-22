class Booking < ApplicationRecord
  # Associations
  belongs_to :parent, class_name: 'User'
  belongs_to :sitter, class_name: 'User'
  belongs_to :availability

  # Model Functions
  def is_status?(status)
    self.status == status
  end
end
