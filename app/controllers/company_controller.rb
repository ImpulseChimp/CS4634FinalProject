class CompanyController < ApplicationController

  before_filter :validateAuthToken, :verify_company

  def dashboard
    @company = get_active_user.company
  end

  def review_manager

  end

  def truck_manager

  end

end