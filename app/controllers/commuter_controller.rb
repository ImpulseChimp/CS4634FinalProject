class CommuterController < ApplicationController

  before_filter :validateAuthToken, :verify_commuter

  def dashboard
    user = get_active_user
    @reviews = user.reviews
  end

  def truck_profile

  end

end