require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it "has a valid factory" do
    expect(build(:recipe)).to be_valid
  end

  it "requires a title" do
    expect(build(:recipe, title: nil)).not_to be_valid
  end

  it "requires a body" do
    expect(build(:recipe, body: nil)).not_to be_valid
  end

  it "allows any combination of the known tags" do
    recipe = build(:recipe, tags: %w[vegan gluten_free])
    expect(recipe).to be_valid
  end

  it "rejects tags outside the known set" do
    recipe = build(:recipe, tags: %w[flexitarian])
    expect(recipe).not_to be_valid
    expect(recipe.errors[:tags]).to be_present
  end

  it "does not include flexitarian among the known tags" do
    expect(Recipe::TAGS).not_to include("flexitarian")
  end
end
