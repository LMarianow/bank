Rails.application.routes.draw do
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
