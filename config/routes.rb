Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true do
      patch :choose_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
