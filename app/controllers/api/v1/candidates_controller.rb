module Api
  module V1
    class CandidatesController < ApplicationController
      before_action :set_candidate, only: [ :show ]

      def index
        @candidates = Candidate.all
        render json: @candidates
      end

      def show
        render json: @candidate
      end

      def create
        @candidate = Candidate.new(candidate_params)

        if @candidate.save
          render json: @candidate, status: :created
        else
          render json: { errors: @candidate.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_candidate
        @candidate = Candidate.find(params[:id])
      end

      def candidate_params
        params.require(:candidate).permit(
          :first_name, :last_name, :email, :contact_number,
          :dob, :education, :experience, :expected_salary,
          :career_phase, :additional_notes, :resume, :photo,
          :intro_video, industries: []
        )
      end
    end
  end
end
