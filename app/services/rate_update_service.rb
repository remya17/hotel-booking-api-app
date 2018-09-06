class RateUpdateService

  attr_reader :hotel_room_type, :error, :options, :result

  def initialize(hotel_room_type, options)
    @hotel_room_type = hotel_room_type
    @options = options
    @error = nil
    @result = {status: :ok, success: false}
  end

  def process
    validate
    return result.merge(status: :unprocessable_entity, error: error) if error.present?
    update_prices
  end

  private

  def validate
    @error = 'Mandatory parameters are missing' and return if options[:start_date].blank? ||
        options[:end_date].blank? || options[:price].to_f <= 0
    validate_dates
  end

  def validate_dates
    begin
      options[:start_date] = Date.strptime(options[:start_date], '%m/%d/%Y')
      options[:end_date] = Date.strptime(options[:end_date], '%m/%d/%Y')
    rescue ArgumentError => e
      @error = "Invalid date format" and return
    end
    @error = "Invalid start date" if options[:start_date] < Date.today || options[:start_date] > options[:end_date]
  end

  def update_prices
    HotelRoomTypeRate.transaction do
      hotel_room_type_rate = HotelRoomTypeRate.where(hotel_room_type: hotel_room_type,
                                                     start_date: options[:start_date],
                                                     end_date: options[:end_date]).first_or_initialize
      hotel_room_type_rate.rate = options[:price]

      update_same_range_rates if hotel_room_type_rate.new_record?
      hotel_room_type_rate.save!

      result.merge(success: true,
                   hotel_room_type_rate_id: hotel_room_type_rate.id
      )
    end
  rescue Exception => e
    result.merge(status: :internal_server_error,
                 error: "Something went wrong. #{e.to_s}"
    )
  end

  def update_same_range_rates
    same_range_hotel_rates = hotel_room_type.rates.in_between_date_range(options[:start_date], options[:end_date])
    same_range_hotel_rates.each {|hr_rate| update_existing_rate_range(hr_rate)}
  end

  def update_existing_rate_range(room_rate)
    # room_rate_
    if room_rate.start_date >= options[:start_date] && room_rate.end_date <= options[:end_date]
      room_rate.destroy!
    elsif room_rate.start_date >= options[:start_date] && room_rate.end_date >= options[:end_date]
      room_rate.start_date = options[:end_date] + 1.day
      room_rate.save!
    elsif room_rate.start_date <= options[:start_date] && room_rate.end_date >= options[:end_date]
      HotelRoomTypeRate.create!(hotel_room_type: hotel_room_type,
                                start_date: options[:end_date] + 1.day,
                                end_date: room_rate.end_date,
                                rate: room_rate.rate) if room_rate.end_date > options[:end_date]
      room_rate.end_date = options[:start_date] - 1.day
      room_rate.save!
    elsif room_rate.start_date <= options[:start_date] && room_rate.end_date <= options[:end_date]
      room_rate.end_date = options[:start_date] - 1.day
      room_rate.save!
    end
  end
end