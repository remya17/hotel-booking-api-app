class Hotel < ApplicationRecord
  has_many :hotel_room_types
  has_many :room_types, through: :hotel_room_types

  validates_presence_of :name

end
