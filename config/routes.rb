QuickSearch::Engine.routes.draw do

  root 'search#index'

  get 'xhr_search' => 'search#xhr_search', :defaults => { :format => 'html' }
  get 'log_event' => 'logging#log_event'
  get 'log_search' => 'logging#log_search'
  get 'typeahead' => 'typeahead#typeahead'

  get 'searcher/:searcher_name' => 'search#single_searcher'
  get 'searcher/:searcher_name/xhr_search' => 'search#xhr_search', :defaults => { :format => 'html' }
  get 'searcher/:searcher_name/log_event' => 'search#log_event'
  get 'searcher/:searcher_name/log_search' => 'search#log_search'


  get 'opensearch' => 'opensearch#opensearch', :defaults => { :format => 'xml' }

  get 'about' => 'pages#about'
  get 'realtime' => 'pages#realtime'

  match 'appstats', to: 'appstats#index', via: [:get, :post]
  match 'appstats/clicks_overview', to: 'appstats#clicks_overview', as: 'clicks_overview', via: [:get, :post]
  match 'appstats/top_searches', to: 'appstats#top_searches', as: 'top_searches', via: [:get, :post]
  match 'appstats/top_spot', to: 'appstats#top_spot', as: 'top_spot', via: [:get, :post]
  match 'appstats/detail/:ga_scope', to: 'appstats#detail', via: [:get, :post]
  get 'appstats/realtime' => 'appstats#realtime'

  ########################## ADDED #############################

  get 'appstats/data_sample', :defaults => { :format => 'json' }
  get 'appstats/data_general_statistics', :defaults => { :format => 'json' }
  get 'appstats/data_module_clicks', :defaults => { :format => 'json' }
  get 'appstats/data_result_clicks', :defaults => { :format => 'json' }
  get 'appstats/data_module_details', :defaults => { :format => 'json' }
  get 'appstats/data_top_searches', :defaults => { :format => 'json' }
  get 'appstats/data_spelling_suggestions', :defaults => { :format => 'json' }


  ##############################################################

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
