require 'rails_helper'

RSpec.describe "Onboardings", type: :request do
  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end

  describe "authentication" do
    it "redirects GET /onboarding to root when signed out" do
      get onboarding_path
      expect(response).to redirect_to(root_path)
    end

    it "redirects PATCH /onboarding/:step to root when signed out" do
      patch step_onboarding_path("personal"), params: { onboarding: { first_name: "Ada" } }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /onboarding" do
    context "when the user has no onboarding yet" do
      let(:user) { create(:user) }

      it "redirects to the first step" do
        sign_in(user)
        get onboarding_path
        expect(response).to redirect_to(step_onboarding_path("personal"))
      end
    end

    context "when the user is mid-wizard" do
      let(:user) { create(:user) }
      let!(:onboarding) { create(:onboarding, user: user, current_step: "address", completed_at: nil) }

      it "redirects to their current step" do
        sign_in(user)
        get onboarding_path
        expect(response).to redirect_to(step_onboarding_path("address"))
      end
    end

    context "when the user has completed onboarding" do
      let(:user) { create(:user) }
      let!(:onboarding) { create(:onboarding, user: user, current_step: "preferences", completed_at: Time.current) }

      it "renders the summary" do
        sign_in(user)
        get onboarding_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(onboarding.first_name)
      end

      it "shows at most 3 recipes even when more match" do
        create_list(:recipe, 5, tags: [])

        sign_in(user)
        get onboarding_path

        cards = Nokogiri::HTML(response.body).css(".card-grid-item")
        expect(cards.size).to eq(3)
      end
    end

    context "when the user is an admin" do
      let(:admin) { create(:user, role: :admin) }
      let!(:other_onboarding) { create(:onboarding, current_step: "address", completed_at: nil) }

      it "renders the admin summary listing every onboarding instead of the wizard or their own summary" do
        sign_in(admin)
        get onboarding_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include(other_onboarding.first_name)
      end
    end
  end

  describe "GET /onboarding/:step" do
    context "when the user has no onboarding yet" do
      let(:user) { create(:user) }

      it "renders the first step" do
        sign_in(user)
        get step_onboarding_path("personal")
        expect(response).to have_http_status(:success)
      end

      it "redirects to the first step when requesting a later step" do
        sign_in(user)
        get step_onboarding_path("address")
        expect(response).to redirect_to(step_onboarding_path("personal"))
      end
    end

    context "when the user is mid-wizard" do
      let(:user) { create(:user) }
      let!(:onboarding) { create(:onboarding, user: user, current_step: "address", completed_at: nil) }

      it "redirects away from a step that isn't their current one" do
        sign_in(user)
        get step_onboarding_path("preferences")
        expect(response).to redirect_to(step_onboarding_path("address"))
      end

      it "renders their current step" do
        sign_in(user)
        get step_onboarding_path("address")
        expect(response).to have_http_status(:success)
      end

      it "allows navigating back to an earlier, already-completed step" do
        sign_in(user)
        get step_onboarding_path("personal")

        expect(response).to have_http_status(:success)
        expect(response.body).to include(onboarding.first_name)
      end
    end

    context "when the user has completed onboarding" do
      let(:user) { create(:user) }
      let!(:onboarding) { create(:onboarding, user: user, current_step: "preferences", completed_at: Time.current) }

      it "renders the summary regardless of the requested step" do
        sign_in(user)
        get step_onboarding_path("personal")
        expect(response).to have_http_status(:success)
        expect(response.body).to include(onboarding.first_name)
      end
    end
  end

  describe "PATCH /onboarding/:step" do
    let(:user) { create(:user) }

    context "on the first step, with no onboarding yet" do
      it "creates the onboarding and advances to the next step" do
        sign_in(user)

        expect {
          patch step_onboarding_path("personal"), params: { onboarding: { first_name: "Ada", last_name: "Lovelace" } }
        }.to change { user.reload.onboarding }.from(nil)

        expect(response).to redirect_to(step_onboarding_path("address"))
        expect(user.onboarding.current_step).to eq("address")
      end

      it "re-renders the step with an error when invalid" do
        sign_in(user)
        patch step_onboarding_path("personal"), params: { onboarding: { first_name: "", last_name: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(user.reload.onboarding).to be_nil
      end
    end

    context "when mid-wizard" do
      let!(:onboarding) { create(:onboarding, user: user, current_step: "address", completed_at: nil) }

      it "advances to the next step on valid params" do
        sign_in(user)
        patch step_onboarding_path("address"), params: {
          onboarding: { address_line_1: "1 Rails St", city: "London", postcode: "E1 6AN" }
        }

        expect(response).to redirect_to(step_onboarding_path("preferences"))
        expect(onboarding.reload.current_step).to eq("preferences")
      end

      it "re-renders the step with an error when invalid" do
        sign_in(user)
        patch step_onboarding_path("address"), params: { onboarding: { address_line_1: "", city: "", postcode: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(onboarding.reload.current_step).to eq("address")
      end

      it "redirects to the current step instead of crashing on a non-existent step" do
        sign_in(user)
        patch step_onboarding_path("not-a-real-step"), params: {}

        expect(response).to redirect_to(step_onboarding_path("address"))
      end

      it "lets the user edit an earlier step and keeps their progress" do
        sign_in(user)
        patch step_onboarding_path("personal"), params: { onboarding: { first_name: "Grace", last_name: "Hopper" } }

        expect(response).to redirect_to(step_onboarding_path("address"))
        onboarding.reload
        expect(onboarding.first_name).to eq("Grace")
        expect(onboarding.last_name).to eq("Hopper")
        expect(onboarding.current_step).to eq("address")
      end
    end

    context "on the final step" do
      let!(:onboarding) { create(:onboarding, user: user, current_step: "preferences", completed_at: nil) }

      it "completes the onboarding and redirects to the summary" do
        sign_in(user)
        patch step_onboarding_path("preferences"), params: { onboarding: { dietary_preferences: [ "vegan" ] } }

        expect(response).to redirect_to(onboarding_path)
        expect(onboarding.reload).to be_completed
      end
    end
  end
end
