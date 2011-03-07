Zachet::Application.routes.draw do
  # admin interface
  constraints :subdomain => 'admin' do
    scope :module => 'admin' do
      root :to => 'welcome#index'
      resources :newsitems, :path => 'news', :except => [:show]
      resources :colleges do
        resources :disciplines, :except => [:show] do
          collection do
            post :import
          end
        end
        resources :faculties, :except => [:show] do
          collection do
            get :import
            post :import
          end
        end
        resources :departments, :except => [:index, :show]
        resources :synopses, :except => [:show]
        resources :cribs, :except => [:show]
        resources :manuals, :except => [:show]
      end
      resources :teachers do
        collection do
          get :get_departments
        end
      end
      resources :users, :except => [:show]
    end
  end

  # forum
  constraints :subdomain => 'forum' do
    root :to => 'forums#index'
    resources :forums, :except => [:index] do
      member do
        get :move_up
        get :move_down
      end
      resources :topics, :only => [:new, :create]
    end
    resources :topics, :except => [:new, :index, :create] do
      resources :posts, :except => [:new, :show, :index]
    end
  end

  constraints :subdomain => 'account' do
    scope :module => 'account' do
      root :to => 'profile#show'
      match 'login' => 'user_sessions#new'
      match 'logout' => 'user_sessions#destroy'
      resource :user_session, :only => [:create]
      resource :profile, :except => [:destroy, :show] do
        member do
          get :my_content
        end
      end
      resource :content, :only => [:show]
      resources :messages, :only => [:index]
      resources :users, :only => [:show]
      resources :password_resets, :only => [:new, :create, :edit, :update]
    end
  end

  constraints :subdomain => /.+/ do
    scope :module => 'college' do
      root :to => 'welcome#index'
      resources :newsitems, :only => [:index, :show], :path => 'news'
    end
  end

  resource :downloads, :only => :show

  constraints :subdomain => '' do
    resources :newsitems, :only => [:index, :show], :path => 'news'
    root :to => 'home#index'
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
