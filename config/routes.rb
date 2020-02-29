Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_reset
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: %i[create destroy update], concerns: :votable, shallow: true do
      patch :choose_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
