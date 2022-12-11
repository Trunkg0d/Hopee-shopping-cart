Rails.application.routes.draw do
  root "static_pages#home"
  get '/search', to: 'static_pages#search'
  get "/help", to: "static_pages#help"
  get "/contact", to: "static_pages#contact"
  get "/blog", to: "static_pages#blog"
  get "/catalogue", to: "static_pages#catalogue"

  get "/signup", to: "users#new"
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create' 
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  #shop
  get '/shop_signup', to: 'shops#new'

  #product
  post '/products/:id/add_product', to: 'products#getProduct', as: 'add_product'
  get '/products/:id/editQuantity', to: 'products#editQuantity', as: 'edit_quantity'
  patch '/products/:id/editQuantity', to: 'products#updateQuantity'
  get '/products/:id/publicProduct', to: 'products#publicProduct', as: 'publicProduct'
  patch '/products/:id/publicProduct', to: 'products#publicProduct'
  get '/products/:id/privateProduct', to: 'products#privateProduct', as: 'privateProduct'
  patch '/products/:id/privateProduct', to: 'products#privateProduct'
  get '/products/:id/sale', to: 'products#sale', as: 'sale'
  patch '/products/:id/sale', to: 'products#sale'
  get '/products/:id/unsale', to: 'products#unsale', as: 'unsale'
  patch '/products/:id/unsale', to: 'products#unsale'
  get '/filter', to: 'products#filter'

  #cart_item

  #cart_session
  post '/cart_sessions/:id/addVoucher', to: 'cart_sessions#addVoucher', as: "addVoucher"

  #order
  post '/cart_sessions/:id/order', to: 'cart_sessions#checkout', as: "checkout"

  #category
  

  resources :shops
  resources :products
  resources :cart_sessions
  resources :cart_items
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :categories
  resources :orders
  resources :vouchers
end
