module Admins
  class SessionsController < Devise::SessionsController
    prepend_before_action :check_captcha, only: [ :create ]
    # layout "admin"

    protected

    def after_sign_in_path_for(resource)
      admin_dashboard_path
    end

    # def after_sign_out_path_for(resource_or_scope)
    #   new_admin_session_path
    # end

    private

    def check_captcha
      return unless failed_attempts > 2
      unless verify_recaptcha
        self.resource = resource_class.new sign_in_params
        respond_with_navigational(resource) { render :new }
      end
    end

    def failed_attempts
      admin = Admin.find_by(email: sign_in_params[:email])
      admin ? admin.failed_attempts : 0
    end

    def respond_with(resource, _opts = {})
      if resource.errors.blank?
        success_response(
          "Logged in successfully!",
          {
            user: resource
          }
        )
      else
        error_response(resource.errors.full_messages.uniq.to_sentence&.humanize)
      end
    end
  end
end
