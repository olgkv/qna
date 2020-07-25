Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_cancel
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: %i[new create show destroy update], shallow: true do
      patch 'best', on: :member
    end
  end


  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
