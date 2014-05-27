# Configuring routing for plugin's controllers.

if Rails::VERSION::MAJOR < 3
  ActionController::Routing::Routes.draw do |map|
#    map.connect "projects/:project_id/smile", :controller => :smile, :action => :index
    map.resources :sidebar, :only => ['toggle'], :collection => {
    'toggle' => :get
    }
  end
else
  RedmineApp::Application.routes.draw do
    match 'sidebar/toggle', :controller => 'sidebar', :action => 'toggle', :via => :get
  end
end

