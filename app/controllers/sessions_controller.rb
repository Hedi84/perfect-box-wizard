class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email]&.downcase)

    user ? sign_in_existing_user(user) : sign_up_new_user
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out successfully."
  end

  private

  def sign_in_existing_user(user)
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to onboarding_path, notice: "Signed in successfully."
    else
      redirect_to root_path, alert: "Invalid email or password."
    end
  end

  def sign_up_new_user
    user = User.new(email: params[:email]&.downcase, password: params[:password])

    if user.save
      session[:user_id] = user.id
      redirect_to onboarding_path, notice: "Account created!"
    else
      redirect_to root_path, alert: user.errors.full_messages.to_sentence
    end
  end
end
