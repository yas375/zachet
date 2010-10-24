ActionController::Routing::Routes.draw do |map|
  map.with_options :conditions => {:subdomain => /admin/}, :name_prefix => 'admin_' do |admin|
    admin.root :controller => 'admin/welcome', :action => 'index'
    admin.resources :newsitems, :controller => 'admin/newsitems', :as => 'news', :except => [:show]
    admin.resources :colleges, :controller => 'admin/colleges' do |college|
      college.resources :disciplines, :controller => 'admin/disciplines', :except => [:show]
      college.resources :faculties, :controller => 'admin/faculties', :except => [:show]
      college.resources :departments, :controller => 'admin/departments', :except => [:index, :show]
      college.resources :synopses, :controller => 'admin/synopses', :except => [:show]
      college.resources :cribs, :controller => 'admin/cribs', :except => [:show]
      college.resources :manuals, :controller => 'admin/manuals', :except => [:show]
    end
    admin.resources :teachers, :controller => 'admin/teachers', :collection => {:get_departments => :get}
    admin.resources :users, :controller => 'admin/users', :except => [:show]
  end

  # forum
  map.with_options :conditions => {:subdomain => /forum/} do |forum|
    forum.root :controller => 'forums', :action => 'index'
    forum.resources :forums, :except => [:index], :member => [:move_up, :move_down] do |f|
      f.resources :topics, :only => [:new, :create]
    end
    forum.resources :topics, :except => [:new, :index, :create] do |topic|
      topic.resources :posts, :except => [:new, :show, :index]
    end
  end

  # subdomains
  map.with_options :conditions => {:subdomain => /.+/}, :name_prefix => 'college_' do |college|
    college.root :controller => 'colleges', :action => 'show'
  end

  # routes only for main site without subdomains
  map.with_options :conditions => {:subdomain => false} do |main|
    main.root :controller => "home"
  end

  # global routes
  map.resources :newsitems, :only => [:index, :show], :as => 'news'
  map.resource :user_session, :only => [:create]
  map.login 'login', :controller => 'user_sessions', :action=> 'new'
  map.logout 'logout', :controller => 'user_sessions', :action=> 'destroy'

  map.resource :account, :except => [:destroy], :controller => 'account'
  map.resources :users, :only => [:show]
  map.resources :password_resets, :only => [:new, :create, :edit, :update]


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
