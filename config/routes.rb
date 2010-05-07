ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :pages

    admin.root :controller => "users", :action => "index"
  end

  map.resources :users
  map.resources :pages
  map.resources :contact_submissions

  map.resource  :session, :controller => "session"
  map.with_options :controller => 'session' do |m|
    m.sign_in             'signin',                   :action => 'new'
    m.sign_out            'signout',                  :action => 'destroy'
    m.signed_out          'signed_out',               :action => 'signed_out'
    m.reset_password      'reset_password/:id/:hash', :action => 'reset_password'
    m.forgot_password     'forgot_password',          :action => 'forgot_password'
  end

  map.root :controller => "home"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
