
ActionController::Routing::Routes.draw do |map|

  map.root :controller => "site", :action => "index"

  map.login 'login', :controller => 'session', :action => 'login'
  map.logout 'logout', :controller => 'session', :action => 'logout'

  map.resources :repositories, :controller => :repository, :as => ':uid' do |repo|
    repo.resources :perms, :controller => :permission
  end

  map.connect '*path', :controller => 'application', :action => 'error' 

end
