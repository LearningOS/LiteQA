Rails.application.routes.draw do
  resources :posts do
    # resources :comments, module: :posts
  end
  devise_for :users, module: "users"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "posts#index"
end
