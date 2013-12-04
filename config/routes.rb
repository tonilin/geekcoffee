Geekcoffee::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root :to => 'pages#welcome'

  resources :maps

  resources :shops do
    collection do
      post :new_step2
    end
  end

end
