class AvailabilityRentService

  attr_reader :hotel_room_type, :error, :move_in_date, :move_out_date, :total_rent

  MINIMUM_BOOKING_DAYS = 30

  def initialize(hotel_room_type, move_in_date, move_out_date)
    @hotel_room_type = hotel_room_type
    @move_in_date = move_in_date
    @move_out_date = move_out_date
    @error = nil
    @total_rent = 0.00
  end

  def process
    validate
    return {status: :unprocessable_entity, error: error, success: false} if error.present?
    get_price_and_availability
  end

  private

  def validate
    @error = 'Mandatory parameters are missing' and return if move_in_date.blank? || move_out_date.blank?
    return unless valid_dates?
    @error = "Move in date should not be a past date or greater than Move out date" and return if booking_dates_invalid?
    @error = "Please select at least #{minimum_booking_days} days range" if minimum_days_mismatch?
  end

  def valid_dates?
    begin
      @move_in_date = Date.strptime(move_in_date, '%m/%d/%Y')
      @move_out_date = Date.strptime(move_out_date, '%m/%d/%Y')
    rescue ArgumentError => e
      @error = "Invalid date format"
      return false
    end
    true
  end

  def booking_dates_invalid?
    move_in_date < Date.today || move_in_date > move_out_date
  end

  def minimum_days_mismatch?
    number_of_days(move_in_date, move_out_date) < minimum_booking_days
  end

  def get_price_and_availability
    available_rooms = get_availability
    calculate_monthly_rent

    {
        status: :ok,
        success: true,
        move_in_date: move_in_date,
        move_out_date: move_out_date,
        available: available_rooms.present?,
        number_of_rooms_available: available_rooms.count,
        available_room_ids: available_rooms,
        monthly_rent: monthly_rent,
        formatted_currency_rent: format_to_currency(monthly_rent)
    }
  end

  def get_availability
    all_room_ids = hotel_room_type.rooms.pluck(:id)
    all_room_ids - booked_room_ids(all_room_ids)
  end

  def booked_room_ids(all_room_ids)
    Booking.where(room_id: all_room_ids).in_between_date_range(move_in_date, move_out_date).pluck(:room_id).uniq
  end

  def calculate_monthly_rent
    rates = hotel_room_type.rates.in_between_date_range(move_in_date, move_out_date).order(:start_date)
    rates.each {|rate| sum_up_total_rent(rate)}
    monthly_rent
  end

  def sum_up_total_rent(rate)
    start_date = (rate.start_date < move_in_date) ? move_in_date  : rate.start_date
    end_date = (rate.end_date > move_out_date) ? move_out_date - 1.day : rate.end_date
    @total_rent += (number_of_days(start_date, end_date) * rate.rate)
  end

  def minimum_booking_days
    MINIMUM_BOOKING_DAYS
  end

  def per_day_average_rent
    @total_rent/(number_of_days(move_in_date, move_out_date) - 1)
  end

  def monthly_rent
    @monthly_rent ||= (per_day_average_rent * 30).round(2)
  end

  def format_to_currency(price)
    ActiveSupport::NumberHelper.number_to_currency(price)
  end

  def number_of_days(start_date, end_date)
    # Including from the start date
    (end_date - start_date).to_i + 1
  end
end