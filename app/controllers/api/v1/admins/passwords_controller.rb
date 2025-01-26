module Api
  module V1
    module Admins
      class PasswordsController < Devise::PasswordsController
        # layout "admin"

        def create
          self.resource = resource_class.send_reset_password_instructions(resource_params)
          yield resource if block_given?

          Rails.logger.info "Reset password attempted for: #{resource_params[:email]}"
          Rails.logger.info "Resource errors: #{resource.errors.full_messages}" if resource.errors.any?

          if successfully_sent?(resource)
            success_response(
              "Reset password instructions have been sent to your email",
              { email: resource_params[:email] }
            )
          else
            error_response(resource.errors.full_messages.uniq.to_sentence&.humanize)
          end
        end

        def update
          self.resource = resource_class.reset_password_by_token(resource_params)
          yield resource if block_given?

          if resource.errors.empty?
            resource.unlock_access! if unlockable?(resource)
            success_response("Password has been reset successfully")
          else
            error_response(resource.errors.full_messages.uniq.to_sentence&.humanize)
          end
        end

        protected

        def after_resetting_password_path_for(resource)
          admin_dashboard_path
        end

        def after_sending_reset_password_instructions_path_for(resource_name)
          new_admin_session_path
        end

        def resource_params
          params.permit(:email).to_h
        end
      end
    end
  end
end
