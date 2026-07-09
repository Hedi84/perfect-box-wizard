class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to onboarding_path, notice: "Signed in successfully."
    else
      redirect_to root_path, alert: "Invalid email or password."
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out successfully."
  end
end
