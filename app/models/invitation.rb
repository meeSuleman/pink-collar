class Invitation < ApplicationRecord
  # Associations
  belongs_to :invited_admin, class_name: "Admin", foreign_key: :email, primary_key: :email, optional: true

  # Validations
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[pending accepted expired] }

  # Callbacks
  before_validation :generate_token, on: :create

  private

  def generate_token
    self.token ||= SecureRandom.hex(16)
  end
end
