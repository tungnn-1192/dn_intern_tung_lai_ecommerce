Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    namespace :admin do
      root "static_pages#index"
      get "login", to: "sessions#new"
      post "login", to: "sessions#create"
      get "logout", to: "sessions#destroy"
    end
    root "static_pages#index"
    get "/home", to: "static_pages#index"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"

    resources :products, only: %i(index show)
    resources :carts, except: %i(new show edit)
  end
end
