Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  # 顶层健康检查接口便于负载均衡和简单探针直接调用。
  get 'health', to: 'health#show'

  namespace :api do
    namespace :v1 do
      # API 版本化健康检查方便后续统一接入 /api/v1 前缀。
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

  # 路由 DSL 详情见 Rails 官方文档。
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
