# app/services/onboarding_wizard.rb

class OnboardingWizard
  Result = Data.define(:success?, :onboarding)

  def initialize(onboarding:, step:, onboarding_params: {})
    @onboarding = onboarding
    @step = step
    @onboarding_params = onboarding_params
  end

  def call
    onboarding.assign_attributes(onboarding_params.merge(current_step: step))

    return failure_result unless onboarding.valid?(step.to_sym)

    advance
    onboarding.save!(validate: false)

    Result.new(success?: true, onboarding:)
  end

  private

  attr_reader :onboarding, :step, :onboarding_params

  def advance
    next_step = Onboarding::STEPS[Onboarding::STEPS.index(step) + 1]

    if next_step
      onboarding.current_step = next_step
    else
      onboarding.completed_at = Time.current
    end
  end

  def failure_result
    Result.new(success?: false, onboarding:)
  end
end
