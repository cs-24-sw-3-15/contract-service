Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "contracts/pending", to: "contracts#pending"

  resources :contracts do
    member do
      get "approve"
      patch "approve"
    end
  end

  patch "contracts/:id/approve", to: "contracts#approve", as: :approve
  resources :contracts, only: [ :index, :show, :new, :create, :destroy ]
  resources :suppliers, only: [ :index, :new, :create ]
  resources :affiliates, only: [ :index, :new, :create ]
  resources :labels, only: [ :index, :show, :new, :create, :destroy ]

  get "dashboard" => "dashboard#index", as: :dashboard
  get "users" => redirect("/contracts"), status: 302
  get "pending_contracts" => redirect("/contracts"), status: 302
  get "notifications", to: "notifications#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root to: redirect("/contracts"), status: 302
end
