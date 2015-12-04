class CommuterController < ApplicationController

  before_filter :verify_commuter

  def dashboard
    @user = get_active_user
    @reviews = @user.reviews
  end

  def reviews

  end

end