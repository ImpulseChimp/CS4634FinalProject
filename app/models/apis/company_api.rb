require_relative('base_api')
class AdminAPI < BaseApi

  def initialize(request, session, cookies)
    super(request, session, cookies)
  end

  def process_request

    if request['api_method'] == 'create-truck'
      return create_truck
    else
      @response['error'] = 'API Method does not exist'
      @response['success'] = false
      return @response
    end

  end

  def create_truck
    @response = {}

    param_list = %w(driver-email license-plate)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    user = get_active_user
    return unsuccessful_response(@response, 'No user logged in') if user.nil?

    return successful_response(@response, 'Truck created')

  end

  def register

    @response = {}

    param_list = %w(user_first_name user_last_name user_email_address user_password user_confirmed_password created_by_admin_id)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    email = Email.where('email_address=?', @request['user_email_address']).first
    if !email.nil?
      return unsuccessful_response(@response, 'Email already in use')
    end

    new_user = create_user(@request['user_first_name'], @request['user_last_name'])
    return unsuccessful_response(@response, 'user can not be created') if new_user.nil?

    new_admin = create_admin(new_user, @request['created_by_admin_id'])
    return unsuccessful_response(@response, 'user can not be created') if new_user.nil?

    new_email = create_email(new_user.user_id, @request['user_email_address'])
    new_password = create_password(new_user.user_id, @request['user_password'], @request['user_confirmed_password'])

    if new_email.nil? || new_password.nil?
      return unsuccessful_response(@response, 'error creating a new user on server side')
    end

    # AdminMailer.sign_up_email(new_user, new_admin).deliver
    new_user.user_verified = true
    new_admin.admin_active = true

    new_user.password = new_password
    new_user.email = new_email

    new_email.save
    new_password.save
    new_user.save
    new_admin.save

    successful_response(@response, 'new admin created')
  end

end