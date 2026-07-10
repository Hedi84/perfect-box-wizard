class OnboardingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_onboarding, unless: :admin_user?

  def show
    return render_admin_summary if admin_user?
    return render_summary if @onboarding.completed?

    current = current_or_first_step
    requested = params[:step]

    if requested.nil? || !Onboarding::STEPS.include?(requested)
      return redirect_to step_onboarding_path(current)
    end

    if Onboarding::STEPS.index(requested) > Onboarding::STEPS.index(current)
      return redirect_to step_onboarding_path(current)
    end

    @step = requested
    render_step
  end

  def resume
  end

  def update
    step = params[:step]

    unless Onboarding::STEPS.include?(step)
      return redirect_to step_onboarding_path(current_or_first_step)
    end

    @step = step

    result = OnboardingWizard.new(
      onboarding: @onboarding,
      step: @step,
      onboarding_params: onboarding_params
    ).call

    if result.success?
      redirect_after(result.onboarding)
    else
      @onboarding = result.onboarding
      render_step(status: :unprocessable_entity)
    end
  end

  private

  def admin_user?
    current_user.admin?
  end

  def render_admin_summary
    @onboardings = Onboarding.includes(:user).order(:created_at)
    render :admin_summary
  end

  def render_summary
    @recipes = RecipeMatcher.new(@onboarding.dietary_preferences).call.sample(3)
    render :summary
  end

  def render_step(status: :ok)
    case @step
    when "personal" then render :personal, status: status
    when "address" then render :address, status: status
    when "preferences" then render :preferences, status: status
    end
  end

  def set_onboarding
    @onboarding = current_user.onboarding || current_user.build_onboarding
  end

  def current_or_first_step
    @onboarding.current_step || Onboarding::STEPS.first
  end

  def redirect_after(onboarding)
    if onboarding.completed_at
      redirect_to onboarding_path
    else
      redirect_to step_onboarding_path(onboarding.current_step)
    end
  end

  def onboarding_params
    params.fetch(:onboarding, {}).permit(
      :first_name, :last_name,
      :address_line_1, :address_line_2, :city, :postcode,
      dietary_preferences: []
    )
  end
end
