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
    return if tags.all? { |tag| TAGS.include?(tag) }

    errors.add(:tags, "must only include #{TAGS.join(", ")}")
  end
end
