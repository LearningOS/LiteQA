Rails.application.routes.draw do
  resources :posts do
    # resources :comments, module: :posts
  end
  devise_for :users, module: "users"

  get '/img/:name', to: redirect('/assets/%{name}', status: 302)

  # Defines the root path route ("/")
  root "posts#index"
end
