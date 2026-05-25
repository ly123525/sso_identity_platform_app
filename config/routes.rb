Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  get 'health', to: 'health#show'

  namespace :api do
    namespace :v1 do
      get 'health', to: 'health#show'
    end
  end

  namespace :admin do
    root to: 'dashboard#index'
    get 'access_denied', to: 'access_denied#show'
    resources :users, only: [:index, :new, :create, :edit, :update] do
      member do
        get :edit_password
        patch :update_password
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
