require 'test_helper'
require File.dirname(__FILE__).sub('test/models','') + 'app/models/apis/user_api'

class APIControllerTest < ActionDispatch::IntegrationTest

  test 'register new user successfully' do

    parameters = {}
    parameters['version'] = 'v1'
    parameters['api_method'] = 'register'
    parameters['user_first_name'] = 'Christopher'
    parameters['user_last_name'] = 'Wood'
    parameters['user_email'] = 'christopherwood@test.com'
    parameters['password'] = 'StrongPassword1'
    parameters['user_confirmed_password'] = 'StrongPassword1'
    parameters['HTTP_type'] = 'POST'

    post :request_manager, { :params => parameters }

  end

end