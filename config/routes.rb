Rails.application.routes.draw do
  root 'questions#index'

  resources :questions, shallow: true do
    resources :answers
  end
end
