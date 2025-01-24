class Candidate < ApplicationRecord
  has_one_attached :resume
  has_one_attached :photo
  has_one_attached :intro_video

  enum :experience, [ :entry_level, :mid_level, :senior, :expert ]
  enum :career_phase, [ :student, :fresher, :experienced, :switching_careers ]

  validates :first_name, :last_name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Updated attachment validations
  validates :resume, attached: true, content_type: [ :pdf ]
  validates :photo, attached: true, content_type: [ "image/png", "image/jpeg" ]
  validates :intro_video, attached: true, content_type: [ "video/mp4" ]
end
