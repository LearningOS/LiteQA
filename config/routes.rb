Rails.application.routes.draw do
  resources :posts do
    # resources :comments, module: :posts
  end
  devise_for :users, module: "users"

  # Defines the root path route ("/")
  root "posts#index"
end
