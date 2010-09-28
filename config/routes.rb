DavarDialer::Application.routes.draw do



  match 'contact_lists/assign' => 'contact_lists#assign', :as => :contact_lists_assign

  match 'contacts/dial/:id' => 'contacts#dial', :as => :contacts_dial
  #post 'contacts/assign'
  #post 'contact_lists/assign'


  match 'agents/approve/:id' => 'agents#approve', :as => :agents_approve

#  match 'contact_lists/assign/:id' => 'contact_lists#assign', :as => :contact_lists_assign

  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'register' => 'agents#new', :as => :register

  resources :contact_lists
  resources :contacts
  resources :sessions
  resources :agents


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

   root :to => "contact_lists#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
