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
  get 'settings' => 'development#settings'

  #User routes
  get 'user_dashboard' => 'user#dashboard'
  get 'user_settings' => 'user#settings'

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

  get ':truck_id' => 'truck#truck_profile'

  # Testing Routes for development (CAN BE REMOVED IN PRODUCTION)
  get 'api_test' => 'test#api_test'



end
