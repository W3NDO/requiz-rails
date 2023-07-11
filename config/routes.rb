Rails.application.routes.draw do
  
  # resources :questions
  # resources :notes
  resources :quizzes
  
  get '/kshn', to: "kshn#index"
  get 'docs/index'
  get 'home/index'
  
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  
  root "home#index"

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
end
