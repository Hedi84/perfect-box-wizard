require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "requires an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "requires a unique email" do
    create(:user, email: "duplicate@example.com")
    user = build(:user, email: "duplicate@example.com")
    expect(user).not_to be_valid
  end

  it "authenticates with the correct password" do
    user = create(:user, password: "password123")
    expect(user.authenticate("password123")).to eq(user)
  end

  it "does not authenticate with an incorrect password" do
    user = create(:user, password: "password123")
    expect(user.authenticate("wrongpassword")).to be false
  end

  it "defaults to the customer role when built via the factory" do
    expect(build(:user).role).to eq("customer")
  end

  it "defaults to the customer role at the database level when no role is given" do
    user = User.new(email: "nobody@example.com", password: "password123")
    expect(user.role).to eq("customer")
  end
end
