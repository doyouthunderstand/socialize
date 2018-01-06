Rails.application.routes.draw do
  resources :users

  get 'sessions/login'
  get 'sessions/login_attempt'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'

  resources :account_activations, only: [:edit]
  
end
