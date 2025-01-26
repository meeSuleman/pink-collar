class Candidate < ApplicationRecord
  has_one_attached :resume
  has_one_attached :photo
  has_one_attached :intro_video

  enum experience: {
    'Fresh': 0,
    '1 - 3 yrs': 1,
    '3 - 5 yrs': 2,
    '5 - 8 yrs': 3,
    '8 - 10 yrs': 4
  }

  validates :first_name, :last_name, :email, :contact_number, :dob, :education, :experience, :expected_salary, :career_phase, :institute, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: {
    message: "has already been used to submit an application"
  }

  # Updated attachment validations
  validates :resume, attached: true, content_type: [ :pdf ]
  validates :photo, attached: true, content_type: [ "image/png", "image/jpeg" ]
  validates :intro_video, attached: true, content_type: [ "video/mp4" ]

  before_validation :normalize_email, if: :email_changed?

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
