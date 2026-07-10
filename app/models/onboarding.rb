# app/models/onboarding.rb

class Onboarding < ApplicationRecord
  STEPS = %w[
    personal
    address
    preferences
  ].freeze

  DIETARY_TAGS = %w[
    vegan
    vegetarian
    pescatarian
    gluten_free
    carnivore
    flexitarian
  ].freeze

  belongs_to :user

  validates :current_step, inclusion: { in: STEPS }

  validates :first_name, :last_name,
            presence: true,
            on: :personal

  validates :address_line_1, :city, :postcode,
            presence: true,
            on: :address

  validate :dietary_preferences_are_valid

  def completed?
    completed_at.present?
  end

  def incomplete?
    !completed?
  end

  private

  def dietary_preferences_are_valid
    return if dietary_preferences.all? { |tag| DIETARY_TAGS.include?(tag) }

    errors.add(:dietary_preferences, "must only include #{DIETARY_TAGS.join(", ")}")
  end
end
