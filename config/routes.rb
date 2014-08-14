Rails.application.routes.draw do
  root to: 'shops#index'
  get :status, to: 'application#status'
  resources :shops, only: [:index, :new, :create, :edit, :update, :destroy]
  post '/transaction', to: 'events#transaction', as: :transaction
end
