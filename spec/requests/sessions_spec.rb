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

    context "with a differently-cased email for an existing user" do
      it "signs the user in without creating a duplicate account" do
        expect {
          post session_path, params: { email: "JANE@Example.com", password: "password123" }
        }.not_to change(User, :count)

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
      it "creates a new account and signs the user in" do
        expect {
          post session_path, params: { email: "nobody@example.com", password: "password123" }
        }.to change(User, :count).by(1)

        new_user = User.find_by(email: "nobody@example.com")
        expect(session[:user_id]).to eq(new_user.id)
        expect(response).to redirect_to(onboarding_path)
      end
    end

    context "with an unknown email and an invalid password" do
      it "does not create an account" do
        expect {
          post session_path, params: { email: "nobody@example.com", password: "" }
        }.not_to change(User, :count)

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end

    context "with a blank email" do
      it "does not create an account" do
        expect {
          post session_path, params: { email: "", password: "password123" }
        }.not_to change(User, :count)

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

    it "does not error when no one is signed in" do
      delete session_path

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
