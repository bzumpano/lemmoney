Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :offers
  end

  root 'offers#index'
end
