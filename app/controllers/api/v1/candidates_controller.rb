module Api
  module V1
    class CandidatesController < ApplicationController
      before_action :set_candidate, only: [ :show ]

      def index
        @candidates = Candidate.all
        success_response("Fetched candidates successfully", @candidates)
      end

      def show
        success_response("Fetched candidate info successfully", @candidate)
      end

      def create
        @candidate = Candidate.new(candidate_params)

        if @candidate.save
          success_response("Candidate created successfully", @candidate)
        else
          error_response(@candidate.errors.full_messages.uniq.to_sentence&.humanize)
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
