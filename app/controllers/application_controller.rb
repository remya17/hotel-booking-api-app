class ApplicationController < ActionController::API

  rescue_from StandardError, with: :api_error
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def parameter_missing(error)
    log_error(error)
    json_response({error: :parameter_missing, exception: error.to_s}, :bad_request)
  end

  def record_not_found(error)
    log_error(error)
    json_response({error: :record_not_found, exception: error.to_s},:not_found)
  end

  def api_error(error)
    log_error(error)
    json_response({error: :api_error, exception: 'Something went wrong'}, :internal_server_error)
  end

  def json_response(data, status = :ok)
    render json: data, status: status
  end

  def log_error(error)
    Rails.logger.info "Exception raised #{error.message}"
    Rails.logger.info "Exception backtrace #{error.backtrace}"
  end

end
