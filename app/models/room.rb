class Room < ApplicationRecord
  belongs_to :hotel_room_type
  has_many :bookings

  validates_presence_of :name
end
