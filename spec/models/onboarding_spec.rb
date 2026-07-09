require 'rails_helper'

RSpec.describe Onboarding, type: :model do
  it "has a valid factory" do
    expect(build(:onboarding)).to be_valid
  end

  it "belongs to a user" do
    onboarding = build(:onboarding, user: nil)
    expect(onboarding).not_to be_valid
  end

  it "requires current_step to be one of the defined steps" do
    onboarding = build(:onboarding, current_step: "not_a_step")
    expect(onboarding).not_to be_valid
  end

  describe "on the :personal step" do
    it "requires first_name and last_name" do
      onboarding = build(:onboarding, first_name: nil, last_name: nil)
      expect(onboarding).not_to be_valid(:personal)
      expect(onboarding.errors[:first_name]).to be_present
      expect(onboarding.errors[:last_name]).to be_present
    end
  end

  describe "on the :address step" do
    it "requires address_line_1, city and postcode" do
      onboarding = build(:onboarding, address_line_1: nil, city: nil, postcode: nil)
      expect(onboarding).not_to be_valid(:address)
      expect(onboarding.errors[:address_line_1]).to be_present
      expect(onboarding.errors[:city]).to be_present
      expect(onboarding.errors[:postcode]).to be_present
    end
  end

  describe "#completed?" do
    it "is true when completed_at is present" do
      onboarding = build(:onboarding, completed_at: Time.current)
      expect(onboarding.completed?).to be true
    end

    it "is false when completed_at is nil" do
      onboarding = build(:onboarding, completed_at: nil)
      expect(onboarding.completed?).to be false
    end
  end

  describe "#incomplete?" do
    it "is the opposite of #completed?" do
      onboarding = build(:onboarding, completed_at: nil)
      expect(onboarding.incomplete?).to be true

      onboarding.completed_at = Time.current
      expect(onboarding.incomplete?).to be false
    end
  end
end
