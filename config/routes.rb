Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => { :sessions => "sessions" }
  resources :users

  scope :path => "views" do 
  	resources :home
  end

  mount API => "/"
end
