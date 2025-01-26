module Api
  module V1
    module Admins
      class SessionsController < Devise::SessionsController
        prepend_before_action :check_captcha, only: [ :create ]
        # layout "admin"

        protected

        def after_sign_in_path_for(resource)
          api_v1_admins_dashboard_path
        end

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
  end
end
