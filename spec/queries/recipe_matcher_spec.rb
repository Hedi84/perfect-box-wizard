require 'rails_helper'

RSpec.describe RecipeMatcher do
  let!(:vegan_recipe) { create(:recipe, tags: %w[vegan]) }
  let!(:vegan_gluten_free_recipe) { create(:recipe, tags: %w[vegan gluten_free]) }
  let!(:vegetarian_recipe) { create(:recipe, tags: %w[vegetarian]) }
  let!(:pescatarian_recipe) { create(:recipe, tags: %w[pescatarian]) }
  let!(:carnivore_recipe) { create(:recipe, tags: %w[carnivore]) }
  let!(:gluten_free_only_recipe) { create(:recipe, tags: %w[gluten_free]) }
  let!(:untagged_recipe) { create(:recipe, tags: []) }

  def match(*preferences)
    described_class.new(preferences).call
  end

  it "vegan: only shows vegan-tagged recipes" do
    expect(match("vegan")).to contain_exactly(vegan_recipe, vegan_gluten_free_recipe)
  end

  it "vegetarian: shows vegan or vegetarian tagged recipes" do
    expect(match("vegetarian")).to contain_exactly(vegan_recipe, vegan_gluten_free_recipe, vegetarian_recipe)
  end

  it "pescatarian: shows vegan, vegetarian, or pescatarian tagged recipes" do
    expect(match("pescatarian")).to contain_exactly(
      vegan_recipe, vegan_gluten_free_recipe, vegetarian_recipe, pescatarian_recipe
    )
  end

  it "carnivore: only shows carnivore-tagged recipes" do
    expect(match("carnivore")).to contain_exactly(carnivore_recipe)
  end

  it "gluten_free: only shows gluten_free-tagged recipes" do
    expect(match("gluten_free")).to contain_exactly(vegan_gluten_free_recipe, gluten_free_only_recipe)
  end

  it "flexitarian: shows everything" do
    expect(match("flexitarian")).to contain_exactly(
      vegan_recipe, vegan_gluten_free_recipe, vegetarian_recipe,
      pescatarian_recipe, carnivore_recipe, gluten_free_only_recipe, untagged_recipe
    )
  end

  it "combines multiple preferences with AND, not OR" do
    expect(match("vegan", "gluten_free")).to contain_exactly(vegan_gluten_free_recipe)
  end

  it "combines a broader preference with gluten_free correctly" do
    vegetarian_gluten_free_recipe = create(:recipe, tags: %w[vegetarian gluten_free])

    expect(match("vegetarian", "gluten_free")).to contain_exactly(
      vegan_gluten_free_recipe, vegetarian_gluten_free_recipe
    )
  end

  it "shows everything when no preferences are given" do
    expect(match).to contain_exactly(
      vegan_recipe, vegan_gluten_free_recipe, vegetarian_recipe,
      pescatarian_recipe, carnivore_recipe, gluten_free_only_recipe, untagged_recipe
    )
  end
end
