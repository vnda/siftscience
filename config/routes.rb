Rails.application.routes.draw do
  root to: 'events#send_event', via: :post
end
