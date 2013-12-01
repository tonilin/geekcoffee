Geekcoffee::Application.routes.draw do
  devise_for :users
  root :to => 'pages#welcome'


  resources :shops

end
