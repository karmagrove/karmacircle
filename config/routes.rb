Rails.application.routes.draw do
  resources :invoices
  # resources :products
  # resources :products
  
  
  resources :events do
    resources :tickets do 
      resources :ticket_purchases
    end
  end
  
  get "content/patron"
  get "content/partner"
  get "content/charity"
  get "/about", :to =>  "visitors#about"
  get '/pricing', :to => "visitors#pricing"

  get "invoices/new"
  mount Payola::Engine => '/payola', as: :payola
  root to: 'visitors#index'
  get 'products/:id', to: 'products#show', :as => :products

  devise_for :users, :controllers => { :registrations => 'registrations' , :omniauth_callbacks => "omniauth_callbacks"}

  devise_scope :user do
    put 'change_plan', :to => 'registrations#change_plan'
    get 'explore', :to => 'registrations#explore'
    post 'explore', :to => 'registrations#post_explore'
    get 'products', :to => 'products#index'
    #resources :products
  end
  resources :users do 
    resources :charity_users
    resources :products
  end
  #resources :charity_users
  resources :charges
  resources :purchases
  resources :charities

  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/facebook/login', to: 'sessions#login'

end
