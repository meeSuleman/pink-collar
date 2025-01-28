module Api
  module V1
    module Admins
      class DashboardController < ApplicationController
        before_action :authenticate_api_v1_admin!

        def index
          @dashboard_data = {
            total_applicants: total_applicants,
            generational_breakdown: generational_breakdown,
            upload_rates: {
              resume: calculate_upload_rate(:resume),
              video: calculate_upload_rate(:intro_video),
              profile_completion: calculate_profile_completion_rate
            },
            industry_distribution: industry_distribution,
            top_cities: top_cities,
            resume_to_video_ratio: calculate_resume_to_video_ratio
          }

          success_response("Dashboard loaded successfully", @dashboard_data)
        end

        def admins_list
          @admins = Admin.all
          success_response("Fetched admins successfully", @admins)
        end

        def show_admin
          @admin = Admin.find(params[:id])
          success_response("Fetched admin successfully", @admin)
        end

        private

        def total_applicants
          Candidate.count
        end

        def generational_breakdown
          current_year = Time.current.year

          candidates_by_generation = Candidate.select("
            CASE
              WHEN EXTRACT(YEAR FROM dob) BETWEEN 2013 AND 2025 THEN 'Alpha'
              WHEN EXTRACT(YEAR FROM dob) BETWEEN 1997 AND 2012 THEN 'Gen Z'
              WHEN EXTRACT(YEAR FROM dob) BETWEEN 1981 AND 1996 THEN 'Millennials'
              WHEN EXTRACT(YEAR FROM dob) BETWEEN 1965 AND 1980 THEN 'Gen X'
              WHEN EXTRACT(YEAR FROM dob) BETWEEN 1946 AND 1964 THEN 'Baby Boomers'
            END as generation,
            COUNT(*) as count
          ")
          .group("CASE
            WHEN EXTRACT(YEAR FROM dob) BETWEEN 2013 AND 2025 THEN 'Alpha'
            WHEN EXTRACT(YEAR FROM dob) BETWEEN 1997 AND 2012 THEN 'Gen Z'
            WHEN EXTRACT(YEAR FROM dob) BETWEEN 1981 AND 1996 THEN 'Millennials'
            WHEN EXTRACT(YEAR FROM dob) BETWEEN 1965 AND 1980 THEN 'Gen X'
            WHEN EXTRACT(YEAR FROM dob) BETWEEN 1946 AND 1964 THEN 'Baby Boomers'
          END")
          .having("COUNT(*) > 0")
          .each_with_object({}) do |result, hash|
            hash[result.generation] = {
              count: result.count,
              percentage: (result.count.to_f / total_applicants * 100).round(2)
            }
          end
        end

        def calculate_upload_rate(attachment_type)
          total = total_applicants
          return 0 if total.zero?

          uploaded_count = Candidate
            .joins("INNER JOIN active_storage_attachments ON active_storage_attachments.record_id = candidates.id")
            .where("active_storage_attachments.record_type = 'Candidate' AND active_storage_attachments.name = ?", attachment_type)
            .distinct
            .count

          (uploaded_count.to_f / total * 100).round(2)
        end

        def calculate_profile_completion_rate
          total = total_applicants
          return 0 if total.zero?

          complete_profiles = Candidate
            .joins("INNER JOIN active_storage_attachments resume ON resume.record_id = candidates.id AND resume.name = 'resume'")
            .joins("INNER JOIN active_storage_attachments video ON video.record_id = candidates.id AND video.name = 'intro_video'")
            .joins("INNER JOIN active_storage_attachments photo ON photo.record_id = candidates.id AND photo.name = 'photo'")
            .distinct
            .count

          (complete_profiles.to_f / total * 100).round(2)
        end

        def industry_distribution
          Candidate.all.each_with_object({}) do |candidate, distribution|
            industry = candidate.industries&.to_s
            function = candidate.function&.to_s

            next if industry.blank? || function.blank?

            distribution[industry] ||= {}
            distribution[industry][function] ||= 0
            distribution[industry][function] += 1

            # Add percentage calculations
            total_in_industry = Candidate.where(industries: candidate.industries).count
            distribution[industry][function] = {
              count: distribution[industry][function],
              percentage: (distribution[industry][function].to_f / total_in_industry * 100).round(2)
            }
          end
        end

        def calculate_resume_to_video_ratio
          resume_count = Candidate
            .joins("INNER JOIN active_storage_attachments ON active_storage_attachments.record_id = candidates.id")
            .where("active_storage_attachments.record_type = 'Candidate' AND active_storage_attachments.name = 'resume'")
            .distinct
            .count

          video_count = Candidate
            .joins("INNER JOIN active_storage_attachments ON active_storage_attachments.record_id = candidates.id")
            .where("active_storage_attachments.record_type = 'Candidate' AND active_storage_attachments.name = 'intro_video'")
            .distinct
            .count

          return 0 if video_count.zero?
          (resume_count.to_f / video_count).round(2)
        end

        def top_cities
          Candidate
            .group(:city)
            .count
            .transform_values { |count| (count.to_f / total_applicants * 100).round(2) }
            .sort_by { |_, percentage| -percentage }
            .to_h
        end
      end
    end
  end
end
