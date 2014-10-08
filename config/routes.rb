Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, :controllers => { 
  	:sessions => "sessions", 
  	registrations: "registrations"  
  }

  scope :path => "views" do 
  	resources :home
  end

  get  'about/terms' => 'about#terms'
  get  'about/privacy' => 'about#privacy'

  mount API => "/"
end
