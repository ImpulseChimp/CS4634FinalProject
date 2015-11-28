class CompanyController < ApplicationController

  before_filter :validateAuthToken, :verify_company

  def dashboard

  end

end