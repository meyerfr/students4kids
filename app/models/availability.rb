class Availability < ApplicationRecord
  belongs_to :sitter, class_name: 'User'
end
