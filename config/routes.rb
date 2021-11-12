Rails.application.routes.draw do
  root "static_pages#index"
  get "cart" => "sessions#cart_index"
  get "cart/add/:id" => "sessions#cart_add", :as => "cart_add"
  delete "cart/remove/(/:id(/:all))" => "session#cart_delete"
end
