Rails.application.routes.draw do
  resources :invoices
  # resources :products
  # resources :products
  get '/cryozone/:product_name', to: 'products#show'
  
  resources :events do
    resources :tickets do 
      resources :ticket_purchases
    end
  end
  
  post '/invoices', :to => 'purchases#send_invoice'

  get "communities/index"
  get "community", :to => "communities#index"
  get "content/patron"
  get "content/partner"
  get "content/charity"
  get "/success", :to =>  "purchases#success"
  get "/about", :to =>  "visitors#about"
  get '/pricing', :to => "visitors#pricing"

  get "invoices/new"
  mount Payola::Engine => '/payola', as: :payola
  root to: 'visitors#index'
  get 'products/:id', to: 'products#show', :as => :products

  devise_for :users, :controllers => { :registrations => 'registrations' , :omniauth_callbacks => "omniauth_callbacks", :invitations => 'users_invitations' }

  devise_scope :user do
    put 'change_plan', :to => 'registrations#change_plan'
    get 'explore', :to => 'registrations#explore'
    post 'explore', :to => 'registrations#post_explore'
    post '/users/invite', :to => "registrations#invite"
    #get 'post_explore', :to => 'content#partner'
    get 'products', :to => 'products#index'
    #resources :products
  end
  resources :users do 
    resources :charity_users
    resources :products do
      get 'success', :to => 'products#success'
    end
  end
  #resources :charity_users
  resources :charges
  resources :purchases
  resources :charities

  get 'auth/facebook/callback', to: 'sessions#create'
  get 'auth/facebook/login', to: 'sessions#login'

  get '/donations', :to => 'donations#index'
  resources :user_invites
  get ":business_name", :to => "users#show"
  #post '/users/invite', :to => "registrations#invite"

  get '/auth/frontdesk', to: 'sessions#authenticate_pike13'
  get '/callback/frontdesk', to: 'sessions#create_pike13'
  

end
