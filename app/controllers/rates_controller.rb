class RatesController < ApplicationController

  include LoadHotelRoom

  def update
    rate_update_service = RateUpdateService.new(@hotel_room_type, permitted_params)
    result = rate_update_service.process
    json_response(result, result[:status])
  end

  private

  def permitted_params
    params.require(:rate).permit(:start_date, :end_date, :price)
  end

end