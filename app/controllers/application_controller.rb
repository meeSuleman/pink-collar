class ApplicationController < ActionController::Base
  # Disable CSRF protection for API requests
  protect_from_forgery with: :null_session

  # If you want to ensure JSON responses
  respond_to :json

  # Skip devise's verify_authenticity_token for API requests
  skip_before_action :verify_authenticity_token, if: :json_request?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def json_request?
    request.format.json?
  end
end
