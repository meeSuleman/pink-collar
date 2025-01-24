class Admin < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Validations
  validates :role, inclusion: { in: %w[admin] }
end
