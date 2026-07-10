class Recipe < ApplicationRecord
  TAGS = %w[
    vegan
    vegetarian
    pescatarian
    gluten_free
    carnivore
  ].freeze

  validates :title, presence: true
  validates :body, presence: true
  validate :tags_are_valid

  private

  def tags_are_valid
    invalid_tags = tags - TAGS

    errors.add(:tags, "must only include #{TAGS.join(", ")}") if invalid_tags.any?
  end
end
