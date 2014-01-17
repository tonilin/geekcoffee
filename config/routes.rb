Geekcoffee::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations"  }

  mount API => '/api'

  root :to => 'pages#welcome'

  resources :maps

  namespace :admin do
    root :to => "shops#index"
    resources :shops
    resources :users
  end

  namespace :account do
    resources :settings
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
