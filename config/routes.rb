Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :questions, shallow: true do
    resources :answers, only: %i[create destroy update], shallow: true do
      patch :choose_best, on: :member
    end
  end
end
