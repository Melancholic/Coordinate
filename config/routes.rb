Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root 'static_pages#home'
  match '/about',to:'static_pages#about', via:'get'
  match '/agreement', to: 'static_pages#agreement', via: 'get'
  #match '/contacts',to:'users_mails#new', via:'get'
  match '/faq', to:'static_pages#faq', via: 'get'
  match '/signup', to: 'users#new', via: 'get'

  resources :sessions, only: [:create, :destroy]
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match 'set_custom_locale', to: 'sessions#set_custom_locale', via: 'post'
  resources :users, except: [:index, :new] do
    
     #add user/id/following and user/id/followers
    member do
      get :verification
      post :sent_verification_mail
    end

    #add user/otherpages (without id!!!)
    collection do
      get :reset_password
      post :recive_email_for_reset_pass
      post :resetpass_recive_pass
      put :do_agree
     end
  end
  resources :cars do
    member do
    end
     #add user/otherpages (without id!!!)
     collection do
       get :info, :defaults => {:format => :json}
      get 'edit' => 'cars#edit_collection'
     end
  end

  resources :users_mails, only: [:create]

  #Profile charts
  namespace :charts,  :defaults => {:format => :json} do
    get :speed_agg_info, to:'tracks#speed_agg_info'
    get :tracks_per_car, to:'tracks#tracks_per_car' 
    get :distance_per_car, to:'tracks#distance_per_car'  
    get :tracks_per_time, to:'tracks#tracks_per_time'  
    get :stats_of_track_by_user, to:'tracks#stats_of_track_by_user'  
  end

  #Homepage Map
  namespace :maps,  :defaults => {:format => :json} do
    resources :cars, only:[:index]
    resources :tracks, only:[:index] do
      get :info, :defaults => { format: :js }
      collection do
        get :info_all, :defaults => { format: :js }
      end
    end
    resources :locations, only:[:index] 
    get :location, to:'locations#show' 
  end

  #GPS Tracker API
  namespace :api,  :defaults => {:format => :json} do
    namespace :v1 do
      post 'login' => 'sessions#login'
      post 'logout' => 'sessions#logout'
      post 'hello' => 'sessions#hello'
      get 'ping' => 'sessions#ping'
      namespace :geodata do
        post 'recive'
      end
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
