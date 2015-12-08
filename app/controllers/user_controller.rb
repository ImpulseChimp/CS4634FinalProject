class UserController < ApplicationController

  before_filter :validateAuthToken

  def dashboard

  end

  def settings
    @user = get_active_user
  end

end