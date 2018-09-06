module LoadHotelRoom
  extend ActiveSupport::Concern

  included do
    before_action :load_hotel_room
  end

  private

  def load_hotel_room
    hotel = Hotel.find(params[:hotel_id])
    room_type = RoomType.find(params[:room_type_id])

    @hotel_room_type = hotel.hotel_room_types.find_by(room_type: room_type)
    raise ActiveRecord::RecordNotFound if @hotel_room_type.nil?
  end

end