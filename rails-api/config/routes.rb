Rails.application.routes.draw do
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/live", to: "health#live"
  get "/ready", to: "health#ready"

  namespace :api do
    resources :activities, only: %i[index create update destroy]
    resources :objectives, only: %i[index create update destroy]
    resources :key_results, only: %i[index create update destroy]
    resources :workstreams, only: %i[index create update destroy]
    resources :key_result_workstreams, only: %i[create destroy]
  end

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
