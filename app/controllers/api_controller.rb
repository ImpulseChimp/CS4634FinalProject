class ApiController < ActionController::Metal

  @error_message

  include ActionController::RequestForgeryProtection
  include AbstractController::Callbacks
  include ActionController::Instrumentation
  include ActionController::ParamsWrapper
  include ActionController::Cookies


  def request_manager

    api_response = {}
    begin

    # For Security Purposes, LOG all request IP addresses that attempt access
    logAccessAttempt

    if validAPIRequest(request)

      api_response = processRequest

    else
      api_response['error'] = @error_message
      api_response['message'] = 'Invalid Request to API'
      api_response['success'] = false
      response.status = 400
    end

    response.body = JSON.pretty_generate(api_response)
    return response

    rescue Exception => e
      api_response = {}
      api_response['error'] = e.message
      api_response['success'] = false
      api_response['backtrace'] = e.backtrace
      response.body = JSON.pretty_generate(api_response)
      return response
    end

  end



  #--------------------HELPER METHODS------------------------

  # Validates that the API request fits the Requirements
  def validAPIRequest(request)

    # Validate request
    if request.host != SITE_DOMAIN
      @error_message = 'Request from invalid domain: ' + request.host
      return false

    elsif request.format != 'json'
      @error_message = 'Request type invalid: JSON type required'
      return false

    elsif params[:version].nil?
      @error_message = 'version parameter missing'
      return false

    elsif params[:api].nil?
      @error_message = 'api parameter missing'
      return false

    elsif params[:method].nil?
      @error_message = 'method parameter missing'
      return false

    end

    return true
  end

  def logAccessAttempt
    accessor = AccessIPAddress.where('access_ip_address=?', request.ip).first
    if !accessor.nil?
      accessor.access_count += 1
      accessor.save
    else
      accessor = AccessIPAddress.new(:access_ip_address => request.ip)
      accessor.save
    end
  end


  # Process the API request and call appropriate API if possible
  def processRequest

    return_val = {}

    if (params['api'] == 'user')
      require(api_folder + 'user_api')
      api = UserAPI.new(params, session, cookies)
      return_val = api.process_request

    elsif (params['api'] == 'admin')
      require(api_folder + 'admin_api')
      api = AdminAPI.new(params, session, cookies)
      return_val = api.process_request

    elsif (params['api'] == 'company')
      require(api_folder + 'company_api')
      api = CompanyApi.new(params, session, cookies)
      return_val = api.process_request

    elsif (params['api'] == 'truck')
      require(api_folder + 'truck_api')
      api = TruckApi.new(params, session, cookies)
      return_val = api.process_request

    else # If API does not exist
      return_val['message'] = 'Requested API does not exist'
      return_val['success'] = false
    end

    return return_val
  end


  # This function will grab the folder where we are storing the API libraries
  def api_folder
    return File.dirname(__FILE__).sub('app/controllers','') + 'app/models/apis/'

  end

  private :validAPIRequest, :logAccessAttempt, :processRequest, :api_folder


end