module Api
  module V1
    class InvitationsController < ApplicationController
      before_action :authenticate_user!

      def create
        @invitation = Invitation.new(invitation_params)

        if @invitation.save
          AdminMailer.invitation_email(@invitation).deliver_later
          success_response("Invitation sent successfully", @invitation)
        else
          error_response(@invitation.errors.full_messages.uniq.to_sentence&.humanize)
        end
      end

      def accept
        @invitation = Invitation.find_by(token: params[:token])

        if @invitation&.pending?
          success_response("Invitation accepted successfully", @invitation)
        else
          error_response("Invalid or expired invitation")
        end
      end

      private

      def invitation_params
        params.require(:invitation).permit(:email)
      end
    end
  end
end
