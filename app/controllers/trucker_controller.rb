class TruckerController < ApplicationController

  before_filter :validateAuthToken, :verify_trucker, except: [:trucker_public_profile, :no_truck_found, :review]

  def dashboard

  end

  def trucker_public_profile
    truck = Truck.where('truck_code=?', params[:truck_id]).first

    if truck.nil?
      truck = Truck.where('truck_license_plate=?', params[:truck_id]).first

      if truck.nil?
        redirect_to no_truck_found_path
      end
    end

    @company_name = truck.company.company_name
    @truck_id = truck.truck_id
    @license_plate = truck.truck_license_plate
    @truck_code = truck.truck_code
  end

  def no_truck_found

  end

  def review
    @truck_id = params[:truck_id]
  end

end