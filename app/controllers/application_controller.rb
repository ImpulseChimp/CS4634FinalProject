class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  def getUser(user_id)
    return User.where('user_id=?', user_id).first
  end

  def valid_user(user)
    !user.nil?
  end

  def successful_response(response, message)
    response['message'] = message
    response['success'] = true
    return response
  end

  def unsuccessful_response(response, message)
    response['message'] = message
    response['success'] = false
    return response
  end

  def email_in_use(email_address)
    email = Email.where('email_address=?', email_address).first

    if email.nil?
      return false
    else
      return true
    end
  end

  def get_email(email_address)
    return Email.where('email_address=?', email_address).first?
  end

  def updateLoginAuthToken(user)

    # If token does not exist, create new one
    if user.auth_token.nil?
      user.auth_token = AuthToken.new
    else
      # Update token for new expiration date
      user.auth_token.auth_token_expires = 24.hours.from_now
    end

    # Save and return existing or newly created token
    user.auth_token.save
    return user.auth_token
  end

  def updateAdminLoginAuthToken(admin)

    # If token does not exist, create new one
    if admin.admin_auth_token.nil?
      admin.admin_auth_token = AdminAuthToken.new
    else
      # Update token for new expiration date
      admin.admin_auth_token.auth_token_expires = 24.hours.from_now
    end

    # Save and return existing or newly created token
    admin.admin_auth_token.save
    return admin.admin_auth_token
  end

  def validateUserPermissions
    permission = validateAuthToken
    if !permission
      redirect_to login_path
    else
      return permission
    end
  end

  # Alternate version of validateAuthToken for when
  # the user must be determined from the session
  def validateAuthToken
    user = get_active_user
    if !user.nil?
      if user.auth_token.nil? || user.auth_token.auth_token_expires < Time.now
        redirect_to login_path
        return false
      else
        return true # Token is still valid
      end
    end

    token_check = AuthToken.where('auth_token_id = ?', cookies[:auth_token]).first
    if !token_check.nil?
      return true
    end

    redirect_to login_path
    return false
  end

  def validateAdminAuthToken
    admin = get_active_admin
    if !admin.nil?
      if admin.admin_auth_token.nil? || admin.admin_auth_token.auth_token_expires < Time.now
        redirect_to admin_path
        return false
      else
        return true # Token is still valid
      end
    end

    redirect_to admin_path
    return false
  end

  # Gets the active user based on the session user_id value
  # Returns nil if no user can be determined
  def get_active_user(cookies=nil)
    auth_token_id = session[:user_id]
    if !auth_token_id.nil?
      auth_record = AuthToken.where('auth_token_id = ?', auth_token_id).first
      if !auth_record.nil?
        user = User.where('user_id = ?', auth_record.user_id).first
        if !user.nil?
          # User was found successfully
          return user
        end
      end
    end

    # Check to see if cookie store can find user
    if !cookies.nil?
      token = AuthToken.where('auth_token_id = ?', cookies[:auth_token]).first
      if !token.nil?
        user = User.where('user_id = ?', token.user_id).first
        if !user.nil?
          # User was found successfully
          return user
        end
      end
    end

    # User was not found
    return nil
  end


  def get_active_admin
    auth_token_id = session[:admin_id]
    if !auth_token_id.nil?
      auth_record = AdminAuthToken.where('auth_token_id = ?', auth_token_id).first
      if !auth_record.nil?
        admin = Admin.where('admin_id = ?', auth_record.admin_id).first
        if !admin.nil?
          # Admin was found successfully
          return admin
        end
      end
    end

    return nil
  end


  def check_logged_in
    user = get_active_user
    if !user.nil?
      redirect_to user_dashboard_path
      return true
    else
      return false
    end
  end


end
