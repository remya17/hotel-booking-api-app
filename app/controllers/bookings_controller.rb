class BookingsController < ApplicationController

  include LoadHotelRoom

  def create
    booking_service = BookingService.new(@hotel_room_type, permitted_params)
    result = booking_service.process
    json_response(result, result[:status])
  end

  private

  def permitted_params
    user_params, booking_params = params.require([:user, :booking])
    permitted_user_params = user_params.permit(:email, :first_name, :last_name)
    permitted_booking_params = booking_params.permit(:move_in_date, :move_out_date)
    permitted_booking_params.merge({user: permitted_user_params})
  end

end
