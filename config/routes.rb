Rails.application.routes.draw do
  scope :api do
    devise_for :users, skip: :all, failure_app: CustomAuthFailure

    devise_scope :user do
      post    'login', to: 'jwt_authentication/sessions#create'
      post    'registration', to: 'jwt_authentication/registrations#create'
      post    'passwords', to: 'jwt_authentication/passwords#create'
      match   'passwords', to: 'jwt_authentication/passwords#update', via: [:patch, :put]
      get     'confirmation', to: 'jwt_authentication/confirmations#show'
      post    'resend_confirmation', to: 'jwt_authentication/confirmations#create'
    end
    resources :users, only: [:index, :show, :update, :destroy] do
      get :by_alias, on: :collection, to: 'users#show'
      resource :password, only: :update, controller: 'users/passwords'
      resources :tributes, only: [:create, :show, :index]
      resources :albums, except: [:new, :edit]
      resources :pages, only: [:index, :show] do
        put :update_tiles
      end
    end
    resources :pages, only: [] do
      resources :tiles, only: [:update, :destroy]
    end
    resources :albums, only: [] do
      resources :records, only: [:index, :update]
      resources :photos, :texts, :videos, except: [:edit, :new, :index]
    end
    scope ':target_type/:target_id', target_type: /(album|tribute|video|photo|text)/ do
      resources :comments, only: [:index, :create, :update, :destroy, :show]
      resources :tiles, only: :create
    end
    resources :main_page, only: :index
    resources :videos_information, only: :show, param: :url
  end

  match '/(*path)', via: :all, to: frontend_page('index.htm')
end
