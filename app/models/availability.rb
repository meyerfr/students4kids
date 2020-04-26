class Availability < ApplicationRecord
  belongs_to :sitter, class_name: 'User'

  def is_status?(status)
    self.status == status
  end
end
