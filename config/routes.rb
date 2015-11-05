Rails.application.routes.draw do
  scope :api do
    devise_for :users, skip: :all, failure_app: CustomAuthFailure

    devise_scope :user do
      post 'login', to: 'jwt_authentication/sessions#create'
      post 'registration', to: 'jwt_authentication/registrations#create'
      post 'passwords', to: 'jwt_authentication/passwords#create'
      match 'passwords', to: 'jwt_authentication/passwords#update', via: [:patch, :put]
      get 'confirmation', to: 'jwt_authentication/confirmations#show'
      post 'resend_confirmation', to: 'jwt_authentication/confirmations#create'
    end
    resources :users, only: [:index, :show, :update, :destroy] do
      get :by_alias, on: :collection, to: 'users#show'
      resource :password, only: :update, controller: 'users/passwords'
      resources :tributes, only: [:index, :show, :create, :update, :destroy]
      resources :albums, except: [:new, :edit] do
        put :update_records
      end
      resources :pages, only: [:index, :show] do
        put :update_tiles
      end
      resources :relationships, only: [:index, :create, :update, :destroy]
    end
    resources :pages, only: [] do
      resources :tiles, only: [:update, :destroy]
    end
    resources :albums, only: [] do
      resources :records, only: [:index, :update]
      resources :photos, :texts, :videos, except: [:edit, :new, :index]
      resources :videos, only: [] do
        put :update_meta_info
      end
    end
    scope ':target_type/:target_id', target_type: /(album|tribute|video|photo|text|relationship)/ do
      resources :comments, only: [:index, :create, :update, :destroy, :show]
      resources :tiles, only: :create
    end
    scope ':target_type/:target_id', target_type: /(albums|photos|videos|texts)/ do
      resources :tags, only: [:index, :create, :destroy]
    end

    resources :main_page, only: :index
    resources :likes, only: [:create, :destroy]

    resources :relationships, only: [] do
      resources :records, only: [:index, :create], controller: 'relationship_records'
    end

    resources :video_informations, only: :show, param: :url
    resources :video_uploads, only: [:new, :create]

    match '*path', via: :all, to: proc { raise ActionController::RoutingError.new('Not Found') }
  end

  match '/(*path)', via: :all, to: frontend_page('index.htm')
end
