require 'rails_helper'

RSpec.describe "User onboarding journey", type: :feature do
  it "signs up, completes the wizard, and lands on the summary with matching recipes" do
    create_list(:recipe, 3, tags: %w[vegan gluten_free])
    create(:recipe, tags: %w[carnivore])

    visit root_path

    fill_in "Email", with: "newbie@example.com"
    fill_in "Password", with: "password123"
    click_button "Continue"

    expect(page).to have_content("Tell us about you")

    fill_in "First name", with: "Ada"
    fill_in "Last name", with: "Lovelace"
    click_button "Continue →"

    expect(page).to have_content("Where should we deliver?")

    fill_in "Address line 1", with: "1 Rails Street"
    fill_in "City", with: "London"
    fill_in "Postcode", with: "E1 6AN"
    click_button "Continue →"

    expect(page).to have_content("What do you love to eat?")

    check "Vegan"
    check "Gluten free"
    click_button "Finish"

    expect(page).to have_content("Welcome, Ada!")
    expect(page).to have_css(".card-grid-item", count: 3)

    expect(User.count).to eq(1)
    expect(Onboarding.count).to eq(1)

    onboarding = Onboarding.last
    expect(onboarding).to be_completed
    expect(onboarding.first_name).to eq("Ada")
    expect(onboarding.last_name).to eq("Lovelace")
    expect(onboarding.address_line_1).to eq("1 Rails Street")
    expect(onboarding.dietary_preferences).to contain_exactly("vegan", "gluten_free")
    expect(onboarding.user.email).to eq("newbie@example.com")
  end
end
