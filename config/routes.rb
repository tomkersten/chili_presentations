ActionController::Routing::Routes.draw do |map|
  map.resources :presentations, :name_prefix => 'project_', :path_prefix => '/projects/:project_id', :member => {:download => :get, :instructions => :get}
  map.connect '/projects/:project_id/presentations/:id/*static_asset_path', :controller => 'presentations', :action => 'show'
end
