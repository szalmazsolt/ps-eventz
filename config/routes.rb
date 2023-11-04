Rails.application.routes.draw do
  resources :categories
  root "events#index"

  # get "events", to: "events#index"
  # get "events/new", to: "events#new", as: "new_event"
  # get "events/:id", to: "events#show", as: "event"
  # get "events/:id/edit", to: "events#edit", as: "edit_event"
  # patch "events/:id", to: "events#update"
  # post "events", to: "events#create"
  # delete "events/:id", to: "events#destroy", as: "delete_event"

  get "events/filter/:filter", to: "events#index", as: "filtered_events"

  resources :events do
    resources :likes
    resources :registrations
  end

  resources :users
  get "signup", to: "users#new"

  resource :session, only: [:new, :create, :destroy]
end
