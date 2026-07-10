require 'rails_helper'

RSpec.describe OnboardingWizard do
  let(:user) { create(:user) }

  describe "#call" do
    context "with a brand new onboarding" do
      let(:onboarding) { user.build_onboarding }

      context "with valid params for the current step" do
        subject(:result) do
          described_class.new(
            onboarding: onboarding,
            step: "personal",
            onboarding_params: { first_name: "Ada", last_name: "Lovelace" }
          ).call
        end

        it "succeeds" do
          expect(result.success?).to be true
        end

        it "persists the onboarding with the submitted attributes" do
          result
          expect(onboarding.reload).to have_attributes(first_name: "Ada", last_name: "Lovelace")
        end

        it "advances current_step to the next step" do
          result
          expect(onboarding.current_step).to eq("address")
        end

        it "does not mark the onboarding as completed" do
          result
          expect(onboarding.completed_at).to be_nil
        end
      end

      context "with invalid params for the current step" do
        subject(:result) do
          described_class.new(
            onboarding: onboarding,
            step: "personal",
            onboarding_params: { first_name: "", last_name: "" }
          ).call
        end

        it "fails" do
          expect(result.success?).to be false
        end

        it "does not persist the onboarding" do
          result
          expect(onboarding).not_to be_persisted
        end

        it "retains the submitted (invalid) attributes for redisplay" do
          result
          expect(onboarding.first_name).to eq("")
        end

        it "populates errors on the onboarding" do
          result
          expect(onboarding.errors[:first_name]).to be_present
        end
      end
    end

    context "with an onboarding already in progress" do
      let(:onboarding) { create(:onboarding, user: user, current_step: "address", completed_at: nil) }

      context "with valid params for the current step" do
        subject(:result) do
          described_class.new(
            onboarding: onboarding,
            step: "address",
            onboarding_params: { address_line_1: "1 Rails St", city: "London", postcode: "E1 6AN" }
          ).call
        end

        it "succeeds and advances to the next step" do
          expect(result.success?).to be true
          expect(onboarding.reload.current_step).to eq("preferences")
        end
      end

      context "with invalid params for the current step" do
        subject(:result) do
          described_class.new(
            onboarding: onboarding,
            step: "address",
            onboarding_params: { address_line_1: "", city: "", postcode: "" }
          ).call
        end

        it "fails and leaves the current_step unchanged" do
          expect(result.success?).to be false
          expect(onboarding.reload.current_step).to eq("address")
        end
      end
    end

    context "on the final step" do
      let(:onboarding) { create(:onboarding, user: user, current_step: "preferences", completed_at: nil) }

      subject(:result) do
        described_class.new(
          onboarding: onboarding,
          step: "preferences",
          onboarding_params: { dietary_preferences: [ "vegan" ] }
        ).call
      end

      it "succeeds" do
        expect(result.success?).to be true
      end

      it "marks the onboarding as completed" do
        result
        expect(onboarding.reload.completed_at).to be_present
      end

      it "saves the submitted preferences" do
        result
        expect(onboarding.reload.dietary_preferences).to eq([ "vegan" ])
      end
    end
  end
end
