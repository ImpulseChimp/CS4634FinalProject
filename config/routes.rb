Rails.application.routes.draw do

  # You can have the root of your site routed with "root"
  root 'landing#index'
  get 'login' => 'landing#login'
  get 'forgot_password' => 'landing#forgot_password'
  get 'signup' => 'landing#signup'

  #Development Routes
  get 'company' => 'development#company_dashboard'
  get 'review_template' => 'development#review_template'
  get 'truck_dashboard' => 'development#truck_dashboard'
  get 'settings' => 'user#settings'

  #User routes
  get 'user_settings' => 'user#settings'

  get 'comdash' => 'commuter#dashboard'
  get 'reviews' => 'commuter#reviews'

  get 'compdash' => 'company#dashboard'
  get 'truck-manager' => 'company#truck_manager'
  get 'review-manager' => 'company#review_manager'

  get 'truck-reviews' => 'trucker#review_manager'

  # ADMIN ROUTES
  get 'admin' => 'admin#login'
  get 'admin_dashboard' => 'admin#dashboard'
  get 'admin_documentation' => 'admin#documentation'
  get 'user_manager' => 'admin#user_manager'
  get 'admin_manager' => 'admin#admin_manager'

  # API ROUTES *Change With Caution*
  # get 'apis', to: ApiController.action(:api_documentation)
  get 'api' => 'api#api_documentation'
  get 'api/:version/' => 'api#api_documentation'

  # Matches all v1 apis requests to the request manager
  match 'api/:version/:api', to: 'api#request_manager', via: :all, constraints: {}
  match 'api/:version/:api/:method', to: 'api#request_manager', via: :all, constraints: {}
  match 'api/:version/:api/:method/:p1', to: 'api#request_manager', via: :all, constraints: {}
  match 'api/:version/:api/:method/:p1/:p2', to: 'api#request_manager', via: :all, constraints: {}
  match 'api/:version/:api/:method/:p1/:p2/:p3', to: 'api#request_manager', via: :all, constraints: {}

  get 'review' => 'trucker#review'
  get 'no_truck_found' => 'trucker#no_truck_found'
  get ':truck_id' => 'trucker#trucker_public_profile'

  # Testing Routes for development (CAN BE REMOVED IN PRODUCTION)
  get 'api_test' => 'test#api_test'



end
