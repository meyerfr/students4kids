class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # has_many :bookings, foreign_key: [:sitter_id, :parent_id]
  has_many :parent_bookings, class_name: "Booking", foreign_key: "parent_id"
  has_many :sitter_bookings, class_name: "Booking", foreign_key: "sitter_id"
  # has_many :bookings, class_name: "User", foreign_key: "sitter_id"
  has_many :availabilities, foreign_key: 'sitter_id'
  has_many :children
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def is_role?(role)
    self.role == role
  end

  def full_name
    "#{first_name} #{last_name}".downcase.titleize
  end
end
