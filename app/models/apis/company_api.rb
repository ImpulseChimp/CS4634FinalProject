require_relative('base_api')
class CompanyApi < BaseApi

  def initialize(request, session, cookies)
    super(request, session, cookies)
  end

  def process_request

    if request['api_method'] == 'create-truck'
      return create_truck
    elsif request['api_method'] == 'get-review'
        return get_review
    else
      @response['error'] = 'API Method does not exist'
      @response['success'] = false
      return @response
    end

  end

  def get_review
    @response = {}

    param_list = %w(review_id)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    review = Review.where('review_id=?', @request['review_id']).first
    return unsuccessful_response(@response, 'no review found') if review.nil?

    reviewer = User.where('user_id=?', review.user_id).first

    @response['reviewer_name'] = reviewer.user_first_name + ' ' + reviewer.user_last_name
    @response['reviewer_email'] = reviewer.email.email_address
    @response['review_score'] = review.review_score

    review_type = ''
    if review.review_type == 0
      review_type = 'Positive'
    elsif review.review_type == 1
      review_type = 'Negative'
    else
      review_type = 'Other'
    end

    @response['review_type'] = review_type

    @response['review_comment'] = review.review_text
    @response['review_tree'] = review.decision_tree
    @response['created_at'] = review.created_at.strftime('%v')

    if get_active_user.user_account_type == 'trucker'
      review.trucker_is_read = 1
      review.save
    elsif get_active_user.user_account_type == 'company'
      review.company_is_read = 1
      review.save
    end

    return successful_response(@response, 'review loaded')
  end

  def create_truck
    @response = {}

    param_list = %w(driver-email license-plate)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    user = get_active_user
    return unsuccessful_response(@response, 'No user logged in') if user.nil?

    company_id = user.company.company_id
    truck_code = SecureRandom.uuid[0..4]
    plate_number = @request['license-plate']

    #Create user
    new_user = create_user('placeholder', 'placeholder')
    new_user.user_account_type = 'trucker'

    trucker_password = 'password'
    new_password = create_password(new_user.user_id, trucker_password, trucker_password)

    #Create truck
    new_email = create_email(new_user.user_id, @request['driver-email'])

    #Link truck to company
    new_truck = Truck.new(:user_id => new_user.user_id, :truck_id => SecureRandom.uuid, :company_id => company_id,
                          :truck_code => truck_code, :truck_license_plate => plate_number)

    #Send invite to trucker
    UserMailer.trucker_invite_email(user.company.company_name, @request['driver-email'], trucker_password).deliver

    new_user.user_verified = true

    new_user.save
    new_password.save
    new_email.save
    new_truck.save

    @response['password'] = trucker_password
    return successful_response(@response, 'Truck created')

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