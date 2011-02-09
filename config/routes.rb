ActionController::Routing::Routes.draw do |map|
  map.with_options :conditions => {:subdomain => /admin/}, :name_prefix => 'admin_' do |admin|
    admin.root :controller => 'admin/welcome', :action => 'index'
    admin.resources :newsitems, :controller => 'admin/newsitems', :as => 'news', :except => [:show]
    admin.resources :colleges, :controller => 'admin/colleges' do |college|
      college.resources :disciplines, :controller => 'admin/disciplines', :except => [:show], :collection => {:import => :post}
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

  map.with_options :conditions => {:subdomain => /account/} do |account|
    account.root :controller => 'account/profile', :action => 'show'
    account.resource :user_session, :controller => 'account/user_sessions', :only => [:create]
    account.login 'login', :controller => 'account/user_sessions', :action=> 'new'
    account.logout 'logout', :controller => 'account/user_sessions', :action=> 'destroy'

    account.resource :profile, :controller => 'account/profile', :except => [:destroy, :show], :member => [:my_content]
    account.resource :content, :controller => 'account/content', :only => [:show]
    account.resources :messages, :controller => 'account/messages', :only => [:index]
    account.resources :users, :controller => 'account/users', :only => [:show]
    account.resources :password_resets, :controller => 'account/password_resets', :only => [:new, :create, :edit, :update]
  end

  # subdomains
  map.with_options :conditions => {:subdomain => /.+/}, :name_prefix => 'college_' do |college|
    college.root :controller => 'college/welcome', :action => 'index'
    college.resources :newsitems, :controller => 'college/newsitems', :only => [:index, :show], :as => 'news'
  end

  # routes only for main site without subdomains
  map.with_options :conditions => {:subdomain => false} do |main|
    main.root :controller => "home"
    main.resources :newsitems, :only => [:index, :show], :as => 'news'
  end

  map.resource :downloads, :only => :show
end
