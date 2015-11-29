require_relative('base_api')
class UserAPI < BaseApi

  def initialize(request, session, cookies)
    super(request, session, cookies)
  end

  def process_request

    if request['api_method'] == 'create'
      create
    elsif request['api_method'] == 'update'
      update
    elsif request['api_method'] == 'delete'
      delete
    elsif request['api_method'] == 'login'
      login
    elsif request['api_method'] == 'logout'
      logout
    elsif request['api_method'] == 'register'
      register
    else
      unsuccessful_response(@response, 'API Method does not exist')
    end

  end

  def get

    param_list = %w(user_id)
    return unsuccessful_response(@response, 'Invalid request') if
        !valid_api_request('GET', request['HTTP_type'], param_list, true)

    user = getUser(request['user_id'])
    return unsuccessful_response(@response, 'User not found') if !valid_user(user)

    valid_get_list = %w(user_id user_first_name user_last_name user_middle_name user_date_of_birth user_verified updated_at)
    @response = activeRecordToArray(user, @response, valid_get_list, 'user')

    successful_response(@response, 'User data loaded')

  end

  def register

    @response = {}

    param_list = %w(user_first_name user_last_name user_email_address user_password user_confirmed_password)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    email = Email.where('email_address=?', @request['user_email_address']).first
    if !email.nil?
      return unsuccessful_response(@response, 'Email already in use')
    end

    new_user = create_user(@request['user_first_name'], @request['user_last_name'])
    new_user.user_account_type = @request['ptype']

    return unsuccessful_response(@response, 'user can not be created') if new_user.nil?

    new_email = create_email(new_user.user_id, @request['user_email_address'])
    new_password = create_password(new_user.user_id, @request['user_password'], @request['user_confirmed_password'])

    if new_email.nil? || new_password.nil?
      return unsuccessful_response(@response, 'error creating a new user on server side')
    end

    if new_user.user_account_type == 'company'
      comp_uuid = SecureRandom.uuid
      new_user.company_id = comp_uuid
      company = Company.new(:user_id => new_user.user_id, :company_id => comp_uuid, :company_name => @request['company_name'])
      company.save
    end

    # UserMailer.sign_up_email(new_user).deliver
    new_user.user_verified = true

    new_user.password = new_password
    new_user.email = new_email

    new_email.save
    new_password.save
    new_user.save

    successful_response(@response, 'new user ' + new_email.email_address + ' created')
  end

  def update

    valid_update_list = %w(user_first_name user_last_name user_middle_name user_date_of_birth)
    return unsuccessful_response(@response, 'Invalid request') if
        !valid_api_request('PATCH', @request['HTTP_type'], valid_update_list, false)

    user = getUser(@request['user_id'])

    if valid_user(user)
      updateActiveRecord(user, @request, valid_update_list)
      successful_response(@response, 'User updated')
    else
      unsuccessful_response(@response, 'User not found')
    end

  end


  def delete

    param_list = %w(user_id)
    return unsuccessful_response(@response, 'Invalid request') if
        !valid_api_request('DELETE', request['HTTP_type'], param_list, true)

    user = getUser(request['user_id'])

    if valid_user(user)

      user.email.delete
      user.password.delete
      user.delete

      successful_response(@response, 'User deleted')
    end
    unsuccessful_response(@response, 'User not found')

  end

  def login

      param_list = %w(email_address password)
      return unsuccessful_response(@response, 'User could not be Authenticated') if !valid_api_request('GET', @request['HTTP_type'], param_list, true)

      user_email = Email.where('email_address=?', @request['email_address']).first
      if (user_email.nil?)
        response['debug_message'] = 'email does not exist'
        return unsuccessful_response(@response, 'User could not be Authenticated')
      end

      user = User.where('user_id=?', user_email.user_id).first
      if (user.nil?)
        response['debug_message'] = 'User for email is nil'
        return unsuccessful_response(@response, 'User could not be Authenticated')
      elsif (!user.user_verified)
        return unsuccessful_response(@response, 'e-mail has not been verified')
      end

      password = Password.where('user_id=?', user.user_id).first
      if password.nil?
        response['debug_message'] = 'user account has no associated password'
        return unsuccessful_response(@response, 'User could not be Authenticated')
      end

      require 'digest/sha1'
      encrypted_password = Digest::SHA1.hexdigest(@request['password'])
      salt = Digest::SHA1.hexdigest(user.user_id)
      encrypted_password= Digest::SHA1.hexdigest(encrypted_password + salt)

      if encrypted_password == password.encrypted_password

        token = updateLoginAuthToken(user)
        session[:user_id] = token.auth_token_id

        if request['remember_me']
          @cookies[:auth_token] = { :value => token.auth_token_id, :expires => 1.month.from_now }
        else
          @cookies[:auth_token] = nil
        end

        @response['account_type'] = user.user_account_type
        return successful_response(@response, 'User Authenticated')
      end

      unsuccessful_response(@response, 'User could not be Authenticated')
  end

  def logout
    user = get_active_user(@cookies)
    return unsuccessful_response(@response, 'No user found') if user.nil?

    user.auth_token.auth_token_id = ''
    user.auth_token.auth_token_expires = Time.now
    session[:user_id] = ''
    user.save

    @cookies.delete(:auth_token)

    return successful_response(@response, 'User logged out')
  end

  def create_user(first_name, last_name)
    user = User.new(user_id: SecureRandom.uuid, user_first_name: first_name,
             user_last_name: last_name, user_username: (first_name + ' ' + last_name), user_verified: false)

    if user.valid?
      return user
    else
      return nil
    end
  end

  def create_password(user_id, password, confirmed_password)

    password_format = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,40}$/

    require 'digest/sha1'
    encrypted_password = Digest::SHA1.hexdigest(password)
    salt = Digest::SHA1.hexdigest(user_id)
    encrypted_password= Digest::SHA1.hexdigest(encrypted_password + salt)

    password_id = SecureRandom.uuid
    created_password = Password.new(user_id: user_id, encrypted_password: encrypted_password, password_id: password_id, reset_key: 0)

    return created_password

  end

  def create_email (user_id, email_address)

    email_format = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

    if email_address.match(email_format)

      email_id = SecureRandom.uuid
      email = Email.new(user_id: user_id, email_id: email_id, email_address: email_address)

      return email if email.valid?
    end

    return nil
  end

end