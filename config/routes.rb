Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :offers do
      member do
        patch :enable
        patch :disable
      end
    end
  end

  root 'offers#index'
end
