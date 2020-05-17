class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # has_many :bookings, foreign_key: [:sitter_id, :parent_id]
  with_options dependent: :destroy do |assoc|
    assoc.has_many :parent_bookings, class_name: "Booking", foreign_key: "parent_id"
    assoc.has_many :sitter_bookings, class_name: "Booking", foreign_key: "sitter_id"
    assoc.has_many :availabilities, foreign_key: 'sitter_id'
    assoc.has_many :children, foreign_key: 'parent_id'
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_inclusion_of :role, in: ['sitter', 'parent', 'admin']

  has_many :parents, foreign_key: 'parent_id', through: :sitter_bookings
  has_many :sitters, foreign_key: 'sitter_id', through: :parent_bookings
  # has_many :bookings, class_name: "User", foreign_key: "sitter_id"
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  def is_role?(role)
    self.role == role
  end

  def full_name
    "#{first_name} #{last_name}".downcase.titleize
  end
end
