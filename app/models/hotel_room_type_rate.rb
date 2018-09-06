class HotelRoomTypeRate < ApplicationRecord
  belongs_to :hotel_room_type

  validates_presence_of :start_date, :end_date, :rate

  scope :in_between_date_range, -> (start_date, end_date) do
    where('(start_date >= ? AND start_date <= ?) OR (start_date >= ? AND end_date <= ?) OR (start_date <= ? AND end_date >= ?)',
          start_date, end_date, start_date, end_date, start_date, start_date)
  end

end
