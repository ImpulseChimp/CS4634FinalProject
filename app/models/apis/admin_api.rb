require_relative('base_api')
class AdminAPI < BaseApi

  def initialize(request, session, cookies)
    super(request, session, cookies)
  end

  def process_request

    if request['api_method'] == 'login'
      return login
    elsif request['api_method'] == 'logout'
      return logout
    elsif request['api_method'] == 'register'
      return register
    else
      @response['error'] = 'API Method does not exist'
      @response['success'] = false
      return @response
    end

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

  def setup_default_account

  end

  def create_default_account

    default_admin_email = 'default@admin.com'
    default_admin_password = 'administrator'

    if Admin.all.length > 0
      return false
    end

    user = create_user('default', 'admin')
    admin = create_admin(user, 'master')
    email = create_email(user.user_id, default_admin_email)
    password = create_password(admin.admin_id, user, default_admin_password, default_admin_password)

    user.user_verified = true
    admin.admin_active = true

    user.password = password
    user.email = email

    email.save
    password.save
    user.save
    admin.save

    return true
  end

  def login

    param_list = %w(email_address password)
    return unsuccessful_response(@response, 'User could not be Authenticated') if !valid_api_request('GET', @request['HTTP_type'], param_list, true)

    if request['email_address'] == 'setup@admin.com' && request['password'] == 'administrator'
      admin_created = create_default_account
      return successful_response(@response, 'Default admin successfully setup') if admin_created
      return unsuccessful_response(@response, 'Admin could not be authenticated first')
    end

    user_email = Email.where('email_address=?', @request['email_address']).first
    if (user_email.nil?)
      response['debug_message'] = 'email does not exist'
      return unsuccessful_response(@response, 'User could not be Authenticated second')
    end

    user = User.where('user_id=?', user_email.user_id).first
    if (user.nil?)
      response['debug_message'] = 'User for email is nil'
      return unsuccessful_response(@response, 'Admin could not be Authenticated third')
    elsif Admin.where('user_id=?', user.user_id).first.nil?
      return unsuccessful_response(@esponse, 'Admin could not be Authenticated fourth')
    elsif (!user.user_verified)
      return unsuccessful_response(@response, 'e-mail has not been verified')
    end

    admin = Admin.where('user_id=?', user.user_id).first

    password = Password.where('user_id=?', user.user_id).first
    if password.nil?
      response['debug_message'] = 'user account has no associated password'
      return unsuccessful_response(@response, 'User could not be Authenticated fifth')
    end

    require 'digest/sha1'
    encrypted_password = Digest::SHA1.hexdigest(@request['password'])
    salt = Digest::SHA1.hexdigest(admin.admin_id)
    encrypted_password= Digest::SHA1.hexdigest(encrypted_password + salt)

    if encrypted_password == password.encrypted_password

      token = updateAdminLoginAuthToken(admin)
      session[:admin_id] = token.auth_token_id

      if request['remember_me']
        @cookies[:auth_token] = { :value => token.auth_token_id, :expires => 1.month.from_now }
      else
        @cookies[:auth_token] = nil
      end

      return successful_response(@response, 'User Authenticated')
    end

    unsuccessful_response(@response, 'User could not be Authenticated sixth')
  end

  def logout
    admin = get_active_admin
    return unsuccessful_response(@response, 'No Admin found') if admin.nil?

    admin.admin_auth_token.auth_token_id = ''
    admin.admin_auth_token.auth_token_expires = Time.now
    session[:admin_id] = ''
    admin.save

    return successful_response(@response, 'Admin logged out')
  end

  def create_admin(user, created_by)
    admin = Admin.new(user_id: user.user_id, admin_id: SecureRandom.uuid, created_by_admin_id: created_by)

    if admin.valid?
      return admin
    else
      return nil
    end
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

  def create_password(admin_id, user, password, confirmed_password)

    password_format = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,40}$/

    require 'digest/sha1'
    encrypted_password = Digest::SHA1.hexdigest(password)
    salt = Digest::SHA1.hexdigest(admin_id)
    encrypted_password= Digest::SHA1.hexdigest(encrypted_password + salt)

    password_id = SecureRandom.uuid
    created_password = Password.new(user_id: user.user_id, encrypted_password: encrypted_password, password_id: password_id, reset_key: 0)

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