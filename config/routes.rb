Rails.application.routes.draw do
  namespace :admin do
    resources :offers
  end

  root 'offers#index'
end
