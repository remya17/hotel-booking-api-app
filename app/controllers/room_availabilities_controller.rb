class RoomAvailabilitiesController < ApplicationController

  include LoadHotelRoom

  def show
    room_availability = AvailabilityRentService.new(@hotel_room_type,
                                                    permitted_params[:move_in_date],
                                                    permitted_params[:move_out_date])
    result = room_availability.process
    json_response(result, result[:status])
  end

  private

  def permitted_params
    params.permit(:move_out_date, :move_in_date)
  end

end
