Rails.application.routes.draw do
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: :create, shallow: true
  end
end
