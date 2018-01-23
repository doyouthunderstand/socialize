Rails.application.routes.draw do
  resources :users
  resources :users do
    member do
      get :confirm_email
    end
  end

  get 'sessions/login'
  get 'sessions/login_attempt'
  get 'log_out' => 'sessions#destroy', :as => 'log_out'
  
end
