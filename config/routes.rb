Rails.application.routes.draw do
  get 'bookmarks/new'
  get 'lists/index'
  get 'lists/show'
  get 'lists/new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # set root path to lists index
  root "lists#index"

  # routes for lists and nested bookmarks
  resources :lists, only: [:index, :show, :new, :create] do
    resources :bookmarks, only: [:new, :create]
  end

  # route for deleting bookmarks
  resources :bookmarks, only: :destroy

  # above sets up the following
  # GET /          → lists#index  (root page)
  # GET /lists     → lists#index  (all lists)
  # GET /lists/new → lists#new    (new list form)
  # POST /lists    → lists#create (create list)
  # GET /lists/:id → lists#show   (show a specific list)
  # GET /lists/:list_id/bookmarks/new → bookmarks#new     (new bookmark form)
  # POST /lists/:list_id/bookmarks    → bookmarks#create  (create bookmark)
  # DELETE /bookmarks/:id             → bookmarks#destroy (delete bookmark)
end
