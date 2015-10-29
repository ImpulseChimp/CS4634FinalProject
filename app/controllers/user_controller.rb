class UserController < ApplicationController

  before_filter :validateAuthToken

  def dashboard

  end

  def settings

  end

end