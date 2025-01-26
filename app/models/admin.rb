class Admin < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :lockable, :timeoutable

  # Configure lockable
  def self.maximum_attempts
    5
  end

  # Validations
  validates :email, presence: true, uniqueness: true

  # Custom timeout
  def timeout_in
    30.days
  end

  # Configure password reset expiry
  def self.reset_password_within
    24.hours
  end

  def name
    "#{first_name} #{last_name}"
  end
end
