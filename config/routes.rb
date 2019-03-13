Rails.application.routes.draw do
#  get 'property_snapshots/new'

#  get 'property_snapshots/create'

  get 'pages/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root to: redirect('/transactions')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products++

  resources :transactions do
    collection {
      post :import
      put :update_multiple
      get :edit
    }
  end

  get 'tenants/archived' => 'tenants#index', :view => "archived", as: 'archived_tenants'
  get 'tenants/all' => 'tenants#index', :view => "all", as: 'all_tenants'
  patch 'tenants/:id/archive' => 'tenants#archive'
  patch 'tenants/:id/unarchive' => 'tenants#unarchive'
  resources :tenants do
    resources :tenant_snapshots
    collection {
      put :update_multiple
      get :edit
    }
  end

  get 'properties/archived' => 'properties#index', :view => "archived", as: 'archived_properties'
  get 'properties/all' => 'properties#index', :view => "all", as: 'all_properties'
  patch 'properties/:id/archive' => 'properties#archive'
  patch 'properties/:id/unarchive' => 'properties#unarchive'
  resources :properties do
    resources :property_snapshots
    collection {
      put :update_multiple
      get :edit
    }
  end

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
