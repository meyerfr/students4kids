class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bookings
  has_many :availabilities
  has_many :children
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def is_role?(role)
    self.role == role
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
