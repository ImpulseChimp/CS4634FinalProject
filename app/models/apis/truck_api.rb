require_relative('base_api')
class TruckApi < BaseApi

  def initialize(request, session, cookies)
    super(request, session, cookies)
  end

  def process_request

    if request['api_method'] == 'get-all-trucks'
      return get_all_trucks
    elsif request['api_method'] == 'get-truck'
      return get_truck
    elsif request['api_method'] == 'submit-review'
      return submit_review
    else
      @response['error'] = 'API Method does not exist'
      @response['success'] = false
      return @response
    end

  end

  def get_truck
    @response = {}

    param_list = %w(truck_id)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    truck = Truck.where('truck_id=?', @request['truck_id']).first
    return unsuccessful_response(@response, 'no truck found') if truck.nil?

    user = User.where('user_id=?', truck.user_id).first


    return successful_response(@response, 'truck loaded')
  end

  def get_all_trucks
    @response = {}

    all_trucks = {}
    Company.all.each do |company|

      company.trucks.each do |truck|
        all_trucks[truck.truck_id] = {}
        all_trucks[truck.truck_id]['value'] = truck.truck_license_plate
        all_trucks[truck.truck_id]['label'] = truck.truck_license_plate
        all_trucks[truck.truck_id]['license_plate'] = truck.truck_license_plate
        all_trucks[truck.truck_id]['truck_code'] = truck.truck_code
        all_trucks[truck.truck_id]['company_name'] = company.company_name
      end

    end


    @response['trucks'] = all_trucks
    return successful_response(@response, 'Trucks received')

  end

  def submit_review
    @response = {}

    user = get_active_user

    user_id = 'n/a'
    if !user.nil?
      user_id = user.user_id
    end

    param_list = %w(truck_id star_rating comments decision_tree)
    return unsuccessful_response(@response, 'Invalid request') if !valid_api_request('POST', @request['HTTP_type'], param_list, true)

    truck = Truck.where('truck_id=?', @request['truck_id']).first
    return unsuccessful_response(@response, 'Truck not found') if truck.nil?

    new_review = Review.new(:review_id => SecureRandom.uuid, :truck_id => truck.truck_id,
             :review_score => @request['star_rating'], :review_text => @request['comments'],
             :decision_tree => @request['decision_tree'], :company_id => truck.company_id, :user_id => user_id)
    new_review.save

    return successful_response(@response, 'Review Submitted')
  end

end