class RecipeMatcher
  ALLOWED_TAGS_BY_PREFERENCE = {
    "vegan" => %w[vegan],
    "vegetarian" => %w[vegan vegetarian],
    "pescatarian" => %w[vegan vegetarian pescatarian],
    "carnivore" => %w[carnivore],
    "gluten_free" => %w[gluten_free],
    "flexitarian" => nil
  }.freeze

  def initialize(dietary_preferences)
    @dietary_preferences = dietary_preferences
  end

  def call
    Recipe.all.select { |recipe| matches?(recipe) }
  end

  private

  attr_reader :dietary_preferences

  def matches?(recipe)
    dietary_preferences.all? do |preference|
      allowed_tags = ALLOWED_TAGS_BY_PREFERENCE[preference]
      allowed_tags.nil? || (recipe.tags & allowed_tags).any?
    end
  end
end
