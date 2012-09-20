ActionController::Routing::Routes.draw do |map|
  map.resources :presentations, :name_prefix => 'project_', :path_prefix => '/projects/:project_id', :collection => {:view => :get}
end
