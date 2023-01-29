Rails.application.routes.draw do
  resources :users do
    member do
      post 'deposit'
      get 'withdraw'
      post 'transference'
      get 'balance'
    end
  end
  resources :accounts

end
