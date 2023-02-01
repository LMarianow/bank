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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
