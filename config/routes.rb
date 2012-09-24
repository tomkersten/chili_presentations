ActionController::Routing::Routes.draw do |map|
  map.resources :presentations, :name_prefix => 'project_', :path_prefix => '/projects/:project_id', :collection => {:view => :get}
  map.connect '/projects/:project_id/presentations/:id/*static_asset_path', :controller => 'presentations', :action => 'show'
end
