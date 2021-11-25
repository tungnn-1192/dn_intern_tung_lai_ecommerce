Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#index"
    get "/home", to: "static_pages#index"

    resources :carts, only: [:index]
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"
    resources :products, only: [:index, :show]
  end
end
