Geekcoffee::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  mount API => '/api'

  root :to => 'pages#welcome'

  resources :maps

  namespace :admin do
    root :to => "shops#index"
    resources :shops
    resources :users
  end

  namespace :account do
    resources :settings do
      collection do
        get :edit_password
        patch :update_password
      end
    end

  end




  resources :shops do
    collection do
      post :new_step2
    end

    member do
      put     :rating
      delete  :cancel_rating
    end
  end

end
