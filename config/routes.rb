Rails.application.routes.draw do
  root "home#index"

  resource :session, only: %i[create destroy]

  resource :onboarding, only: [ :show ] do
    get :resume
    get ":step", action: :show, as: :step
    patch ":step", action: :update
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
