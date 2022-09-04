Rails.application.routes.draw do
  resources :posts do
    # resources :comments, module: :posts
    get 'cid/:cid', to: "posts#cid_redirect", on: :collection
  end

  devise_for :users, module: "users"

  # Defines the root path route ("/")
  root "posts#index"
end
