# For more Rails 3 Routing info: http://www.engineyard.com/blog/2010/the-lowdown-on-routes-in-rails-3/
# or generate see auto-generated routes.rb file in a test application
Nibbler::Application.routes.draw do

  ActiveAdmin.routes(self)

  # devise_for :admin_users, ActiveAdmin::Devise.config

  resources :users
  resources :contact_submissions
  resources :trucks
  resource  :session, :controller => "session" # Rails expects "sessions"

  root :to => "home#index"

  # short-hand for: match  'sign_out', :to => "session#destroy"
  match  "sign_out"                 => "session#destroy"
  match  "signed_out"               => "session#signed_out"
  match  "reset_password/:id/:hash" => "session#reset_password", :as => "reset_password"
  match  "forgot_password"          => "session#forgot_password"
  match  "sign_in"                  => "session#new"

  # Error Pages
  match "static/403"
  match "static/404"
  match "static/422"
  match "static/500"

  # Health Check
  match "health_check/check" => "health_check#health_check"
  match "health_check/ok"    => "health_check#ok"
  match "health_check/error" => "health_check#error"
end