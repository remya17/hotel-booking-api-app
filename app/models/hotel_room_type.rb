class HotelRoomType < ApplicationRecord

  belongs_to :hotel
  belongs_to :room_type

  has_many :rates, class_name: "HotelRoomTypeRate"
  has_many :rooms

end
