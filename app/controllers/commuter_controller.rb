class CommuterController < ApplicationController

  before_filter :validateAuthToken, :verify_commuter

  def dashboard

  end

  def truck_profile

  end

end