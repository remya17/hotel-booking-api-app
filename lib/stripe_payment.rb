class StripePayment
  Stripe.api_key = "sk_test_32EQAi8W6LtXD6YEuzxe4ITk"

  STRIPE_TIMEOUT = 10

  attr_reader :options, :response

  def initialize(options)
    @options = options
    @response = {status: :ok}
  end

  def charge_card
    get_token
    if response[:status] != :ok
      log_error(response)
      return response
    end

    options[:token] = response[:result].id
    create_charge

    log_error(response) if response[:status] != :ok
    response
  end

  private

  def create_charge
    stripe_process do
      Stripe::Charge.create(
          :amount => convert_to_cents,
          :currency => "usd",
          :source => options[:token], # obtained with Stripe.js
          :description => options[:description]
      )
    end
  end

  def convert_to_cents
    (options[:amount] * 100).to_i
  end

  def get_token
    # Adding dummy card number
    # This token should be getting from Stripe.js checkout page
    stripe_process do
      Stripe::Token.create(
          :card => {
              :number => "4242424242424242",
              :exp_month => 9,
              :exp_year => 2019,
              :cvc => "314"
          },
      )
    end
  end

  def timeout_time
    STRIPE_TIMEOUT
  end

  def stripe_process
    begin
      Timeout::timeout(timeout_time) do
        response[:result] = yield
      end
    rescue Stripe::CardError, # Since it's a decline, Stripe::CardError will be caught
        Stripe::RateLimitError, # Too many requests made to the API too quickly
        Stripe::InvalidRequestError, # Invalid parameters were supplied to Stripe's API
        Stripe::AuthenticationError, # Authentication with Stripe's API failed. (maybe you changed API keys recently)
        Stripe::APIConnectionError, # Network communication with Stripe failed
        Stripe::StripeError => e # Display a very generic error to the user
      response[:result] = e
      error_handler
    rescue => e
      response[:status] = :internal_server_error
      response[:error] = e.message
    end
  end

  def error_handler
    response[:status] = :internal_server_error
    body = response[:result].json_body
    err = body[:error]
    response[:error] = "Status: #{response[:result].http_status} Code: #{err[:code]}, Err Type: #{err[:type]}"
  end

  def log_error(error)
    Rails.logger.info "Stripe error -- #{error.inspect}"
  end
end