module Api
  module V1
    class InvitationsController < ApplicationController
      before_action :authenticate_user!

      def create
        @invitation = Invitation.new(invitation_params)
        
        if @invitation.save
          AdminMailer.invitation_email(@invitation).deliver_later
          render json: { message: 'Invitation sent successfully' }, status: :created
        else
          render json: { errors: @invitation.errors }, status: :unprocessable_entity
        end
      end

      def accept
        @invitation = Invitation.find_by(token: params[:token])
        
        if @invitation&.pending?
          render json: { token: @invitation.token }
        else
          render json: { error: 'Invalid or expired invitation' }, status: :not_found
        end
      end

      private

      def invitation_params
        params.require(:invitation).permit(:email)
      end
    end
  end
end 