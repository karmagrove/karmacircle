Rails.application.routes.draw do
  get "content/patron"
  get "content/partner"
  get "content/charity"
  get "/about", :to =>  "visitors#about"

  get "invoices/new"
  mount Payola::Engine => '/payola', as: :payola
  root to: 'visitors#index'
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users, :controllers => { :registrations => 'registrations' , :omniauth_callbacks => "omniauth_callbacks"}
  devise_scope :user do
    put 'change_plan', :to => 'registrations#change_plan'
  end
  resources :users do 
    resources :charity_users
  end
  #resources :charity_users
  resources :charges
  resources :charities


end
