class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  protect_from_forgery with: :exception
  # before_action :authenticate_admin!

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
