Rails.application.routes.draw do
  get 'users_mails/new'

  get 'users_mails/create'

  get 'users_mails/new'

  get 'users_mails/create'

  ActiveAdmin.routes(self)
  root 'static_pages#home'
  match '/about',to:'static_pages#about', via:'get'
  #match '/contacts',to:'users_mails#new', via:'get'
  match '/faq', to:'static_pages#faq', via: 'get'
  match '/signup', to: 'users#new',via: 'get' 
  
  resources :sessions, only: [:new, :create, :destroy];
  match '/signin', to: 'sessions#new', via:'get';
  match '/signout', to:'sessions#destroy', via:'delete';
  resources :users, except: [:index] do
    
     #add user/id/following and user/id/followers
    member do
      get :verification
      post :sent_verification_mail
      get :charts_controller, :defaults => {:format => :json}
    end
     #add user/otherpages (without id!!!)
     collection do
      get :reset_password
      post :recive_email_for_reset_pass
      post :resetpass_recive_pass
     end
  end
  resources :cars do
    member do
    end
     #add user/otherpages (without id!!!)
     collection do
      get :info, :defaults => {:format => :json};
      get 'edit' => 'cars#edit_collection'
     end
  end

  resources :users_mails, only:[:create];

  namespace :maps,  :defaults => {:format => :json} do
    resources :cars, only:[:index]
    resources :tracks, only:[:index]
    resources :locations, only:[:index] 
    get :location, to:'locations#show' ;
  end

  namespace :api,  :defaults => {:format => :json}do
    namespace :v1 do
      post 'login' => 'sessions#login'
      post 'logout' => 'sessions#logout'
      post 'hello' => 'sessions#hello'
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
