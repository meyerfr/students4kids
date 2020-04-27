class Availability < ApplicationRecord
  belongs_to :sitter, class_name: 'User'

  def has_status?(status)
    self.status == status
  end
end
