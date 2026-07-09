require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /session" do
    let!(:user) { create(:user, email: "jane@example.com", password: "password123") }

    context "with valid credentials" do
      it "signs the user in and redirects to the onboarding wizard" do
        post session_path, params: { email: "jane@example.com", password: "password123" }

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(onboarding_path)
      end
    end

    context "with an invalid password" do
      it "does not sign the user in" do
        post session_path, params: { email: "jane@example.com", password: "wrongpassword" }

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with an unknown email" do
      it "does not sign the user in" do
        post session_path, params: { email: "nobody@example.com", password: "password123" }

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /session" do
    let!(:user) { create(:user) }

    it "signs the user out and redirects to the root path" do
      post session_path, params: { email: user.email, password: "password123" }

      delete session_path

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
