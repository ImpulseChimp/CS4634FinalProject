class LandingController < ApplicationController

  before_filter :check_logged_in

  def index
	@total_trucks = Truck.all.size
  end

  def signup

  end

  def login

  end

  def forgot_password

  end

end
