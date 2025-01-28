class Candidate < ApplicationRecord
  has_one_attached :resume
  has_one_attached :photo
  has_one_attached :intro_video

  enum experience: {
    'Fresh': 0,
    '1-3 Years': 1,
    '3-5 Years': 2,
    '5-8 Years': 3,
    '8-10 Years': 4,
    '10+ Years': 5

  }

  enum function: {
    "marketing" => 0,
    "sales" => 1,
    "human_resources" => 2,
    "finance_and_accounting" => 3,
    "procurement_and_purchasing" => 4,
    "supply_chain" => 5,
    "logistics_and_warehouse" => 6,
    "it" => 7,
    "administration" => 8,
    "operations_management" => 9,
    "customer_service_and_support" => 10,
    "business_development" => 11,
    "legal_and_compliance" => 12,
    "product_management" => 13,
    "project_management" => 14,
    "research_and_development" => 15,
    "quality_assurance" => 16,
    "engineering" => 17,
    "design_and_creative" => 18,
    "consulting" => 19,
    "public_relations_and_communications" => 20,
    "demand_planning" => 21,
    "health_safety_and_environment" => 22,
    "corporate_social_responsibility_and_sustainability" => 23,
    "consumer_insight" => 24,
    "other_function" => 25
  }

  enum education: {
    "matriculation_o_levels" => 0,
    "intermediate_a_levels" => 1,
    "diploma_certification" => 2,
    "bachelors_degree" => 3,
    "masters_degree" => 4,
    "mphil_ms" => 5
  }

  INDUSTRIES = [
    "fast_moving_consumer_goods",
    "information_technology",
    "healthcare_and_pharmaceuticals",
    "banking_and_financial_services",
    "retail_and_electronic_commerce",
    "manufacturing_and_production",
    "telecommunications",
    "education_and_training",
    "media_and_entertainment",
    "real_estate_and_construction",
    "automotive",
    "energy_and_utilities",
    "logistics_and_transportation",
    "hospitality_and_tourism",
    "nonprofit_and_nongovernmental_organizations",
    "textile",
    "aviation",
    "financial_technology",
    "microfinance_and_electronic_banking",
    "agriculture",
    "energy_and_power_sector",
    "other"
  ].freeze

  validates :first_name, :last_name, :email, :contact_number, :dob, :education, :experience, :expected_salary, :career_phase, :institute, :address, :city, :state, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { message: "has already been used to submit an application" }
  validates :current_salary, presence: true, if: :currently_employed?
  validates :current_employer, presence: true, if: :currently_employed?
  validates :function, presence: true, if: :currently_employed?
  # Updated attachment validations
  validates :resume, attached: true, content_type: [ :pdf ]
  validates :photo, attached: true, content_type: [ "image/png", "image/jpeg" ]
  validates :intro_video, content_type: [ "video/mp4" ], if: :intro_video_attached?
  validate :validate_industries

  before_validation :normalize_email, if: :email_changed?

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def intro_video_attached?
    intro_video.attached?
  end

  # Helper method to get human readable industries
  def industry_names
    industries.map { |i| i.titleize }
  end

  def validate_industries
    return if industries.blank?

    industries.each do |industry|
      unless INDUSTRIES.include?(industry)
        errors.add(:industries, "#{industry} is not a valid industry")
      end
    end
  end
end
