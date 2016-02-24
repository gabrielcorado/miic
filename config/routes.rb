Rails.application.routes.draw do
  # API
  namespace :api, defaults: { format: 'json' } do
    # Users
    resources :users, only: [:index, :show, :create, :update, :destroy] do
      # Follow actions
      post :follow
      post :unfollow

      # Followers
      get :following
      get :followers
    end

    # Posts
    # resources :posts
  end

  # Root page
  root 'home#index'

  # Make it SPA
  match '*path', to: 'home#index', via: [:get]
end
