require_relative('base_api')
class TruckApi < BaseApi

  def initialize(request, session, cookies)
    super(request, session, cookies)
  end

  def process_request

    if request['api_method'] == 'get-all-trucks'
      return get_all_trucks
    else
      @response['error'] = 'API Method does not exist'
      @response['success'] = false
      return @response
    end

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

end