class Booking < ApplicationRecord
  belongs_to :parent, class_name: 'User'
  belongs_to :sitter, class_name: 'User'
  belongs_to :availability
end
