class OnboardingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_onboarding

  def show
    return render :summary if @onboarding.completed?

    step = current_or_first_step
    return redirect_to step_onboarding_path(step) if params[:step] != step

    @step = step
    render @step
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
      render @step, status: :unprocessable_entity
    end
  end

  private

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
