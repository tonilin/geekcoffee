Geekcoffee::Application.routes.draw do
  devise_for :users
  root :to => 'pages#welcome'

  resources :maps

  resources :shops do
    collection do
      post :new_step2
    end
  end

end
