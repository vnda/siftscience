Rails.application.routes.draw do
  root to: 'events#bad_user_form'
  post '/transaction', to: 'events#transaction'
  post '/bad_user', to: 'events#bad_user'
end
