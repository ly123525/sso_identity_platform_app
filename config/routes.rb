Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  namespace :admin do
    root to: 'dashboard#index'
    get 'access_denied', to: 'access_denied#show'
    resources :users, only: [:index, :new, :create]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
