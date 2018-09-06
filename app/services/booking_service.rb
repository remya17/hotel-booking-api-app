class BookingService

  attr_reader :hotel_room_type, :result, :error, :options, :user, :availability

  def initialize(hotel_room_type, options)
    @hotel_room_type = hotel_room_type
    @options = options
    @error = nil
    @result = {status: :ok, booked: false, success: false}
  end

  def process
    validate
    return result.merge(status: :unprocessable_entity, error: error) if error.present?
    check_availability
    return result if result[:error].present?
    book_room
  end

  private

  def validate
    @error = 'Mandatory parameters are missing' and return if options[:user][:email].blank? ||
        options[:user][:first_name].blank? || options[:user][:last_name].blank?
  end

  def check_availability
    @availability = AvailabilityRentService.new(hotel_room_type, options[:move_in_date],
                                                options[:move_out_date]).process
    if availability_error.present?
      result.merge!(error: availability_error,
                    status: :unprocessable_entity
      )
    end
  end

  def availability_error
    if !availability[:success]
      availability[:error]
    elsif !rooms_available?
      'Rooms are not available.'
    end
  end

  def rooms_available?
    !availability[:number_of_rooms_available].zero?
  end

  def book_room
    Booking.transaction do
      find_or_create_user
      booking = create_booking

      payment_response = make_payment(booking)
      raise Stripe::StripeError if payment_response[:status] != :ok

      booking.payment_transaction_id = payment_response[:result].id
      booking.save!

      result.merge(booked: true,
                   success: true,
                   booking_id: booking.id,
                   monthly_rent: availability[:monthly_rent],
                   formatted_currency_rent: availability[:formatted_currency_rent]
      )
    end
  rescue Stripe::StripeError => e
    result.merge(status: :payment_required,
                 error: 'Payment failure occurred. Please retry again.'
    )
  rescue Exception => e
    result.merge(status: :internal_server_error,
                 error: 'Something went wrong ' + e.to_s
    )
  end

  def find_or_create_user
    @user = User.find_or_create_by!(options[:user])
  end

  def create_booking
    Booking.create!(user: user,
                    room_id: allocate_room_id,
                    move_in_date: availability[:move_in_date],
                    move_out_date: availability[:move_out_date],
                    monthly_rent: availability[:monthly_rent])
  end

  def allocate_room_id
    availability[:available_room_ids].sort.first
  end

  def make_payment(booking)
    stripe_obj = StripePayment.new(
        amount: booking.monthly_rent,
        description: "Charged for booking room with Booking ID ##{booking.id}"
    )
    stripe_obj.charge_card
  end
end