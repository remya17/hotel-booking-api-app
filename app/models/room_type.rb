class RoomType < ApplicationRecord
  has_many :hotel_room_types
  has_many :hotels, through: :hotel_room_types
  has_many :rooms

  validates_presence_of :name

end
