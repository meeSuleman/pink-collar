class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  protect_from_forgery with: :null_session
  # before_action :configure_permitted_parameters, if: :devise_controller?

  def success_response(message = nil, data = nil)
    response = {
      message: message,
      status: "success",
      data: data
    }.compact

    render json: response, status: :ok
  end

  def error_response(message = nil, error = nil, status: :bad_request)
    response = {
      status: "error",
      message: message,
      error: error
    }.compact

    render json: response, status: status
  end

  private

  def json_request?
    request.format.json?
  end
end
