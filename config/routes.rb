Rails.application.routes.draw do
  root 'sessions#new'
  get 'sessions/new'
  get    'sign_in'   => 'sessions#new'
  post   'sign_in'   => 'sessions#create'
  delete 'sign_out'  => 'sessions#destroy'

  resources :users do
    member do
      post 'deposit'
      get 'withdraw'
      post 'transference'
      get 'balance'
      get 'extract'
    end
  end
  resources :accounts

end
