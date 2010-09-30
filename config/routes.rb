# For more Rails 3 Routing info: http://www.engineyard.com/blog/2010/the-lowdown-on-routes-in-rails-3/
# or generate see auto-generated routes.rb file in a test application
FreshRailsApp::Application.routes.draw do

  # Admin Section
  namespace :admin do
    resources :users
    resources :administrators
    resources :pages

    root :to => "users#index"
  end

  resources :users
  resources :pages
  resources :contact_submissions
  resource  :session, :controller => "session" # Rails expects "sessions"

  # short-hand for: match  'sign_out', :to => "session#destroy"
  match  'sign_out'                 => "session#destroy"
  match  "signed_out"               => "session#signed_out"
  match  "reset_password/:id/:hash" => 'session#reset_password'
  match  'forgot_password'          => 'session#forgot_password'
  match  'sign_in'                  => "session#new"

  root :to => "home#index"

  #TODO : Do we need health_check any more?
  # map.with_options :controller => "health_check" do |m|
  #   m.connect "health_check/check", :action => "health_check"
  #   m.connect "health_check/ok",    :action => "ok"
  #   m.connect "health_check/error", :action => "error"
  # end
end