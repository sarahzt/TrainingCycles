Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

    # (change default root path later if needed)
    root to: 'sessions#new'
    
    # run calendars->create on get (instead of default post)
    get '/calendars' => 'calendars#create', as: :create_calendar
    # run calendars->create on get (instead of default post)
    get '/events' => 'events#create', as: :create_event
    
    # pass date as id of sorts for new user_workout form
    get '/user_workouts/:date' => 'user_workouts#new', as: :show_user_workout_today

    resources :calendars, :events, :sessions, :training_cycles, :users, :google_logins, :dashboards, :user_workouts # limit methods when finished

    # access all workouts for a plan via 'plans/1/workouts' route
    resources :plans do
      resources :workouts
    end

    # route to log in page
    get "/log-in" => 'sessions#new' 
    
    # run log in method (Google OAuth2) - need to reset controller
    get "/auth/:provider/callback" => 'google_logins#create'
    
    # run log out method
    get "/log-out" => 'sessions#destroy'

    # run custom search method
    get "/plans/search" => 'plans#search', as: :search_plans
    get "/plans/search/results" => 'plans#results', as: :search_plans_results

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
